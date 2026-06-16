/*
c-rusted-rs chimera.

Compact showcase for the main checks currently implemented by the prototype
(e.g.nominal typing, custom state properties, borrowing, and ownership/move
rules).
*/

#include "./include/crusted.h"

// ================================================================
//                           API demo
// ================================================================

int atoi(const char *str);

typedef int e_type Mixer_t;
typedef Mixer_t *hMixer_t;

e_uninit() e_own Mixer_t *alloc_mixer(int id);

void mixer_ctor(
    e_init()
    e_out("cable", "detached")
    e_out("blade", "?")
    e_out("door", "?")
    hMixer_t mxp
);

void mixer_attach_cable(
    e_initialized()
    e_in("blade", "off")
    e_out("cable", "attached")
    hMixer_t mxp
);

void mixer_detach_cable(
    e_initialized()
    e_in("blade", "off")
    e_out("cable", "detached")
    hMixer_t mxp
);

void mixer_on(
    e_initialized()
    e_in("cable", "attached")
    e_in("door", "closed")
    e_out("blade", "on")
    hMixer_t mxp
);

void mixer_off(
    e_initialized()
    e_out("blade", "off")
    hMixer_t mxp
);

void mixer_open(
    e_initialized()
    e_in("blade", "off")
    e_out("door", "open")
    hMixer_t mxp
);

void mixer_close(
    e_initialized()
    e_out("door", "closed")
    hMixer_t mxp
);

void mixer_destroy(hMixer_t e_own mxp);
void inspect_mixer(const Mixer_t *mxp);
void service_mixer(Mixer_t *mxp);

// ================================================================
//                          Showcase
// ================================================================

e_uninit() e_own Mixer_t *alloc_mixer(int id) {
    if (id == 0) {
        // violation: `Mixer_t *` is nominally distinct from `int *`
        return (int *)0;
    }

    return (Mixer_t *)42;
}

void mixer_on(
    e_initialized()
    e_in("cable", "attached")
    e_in("door", "closed")
    e_out("blade", "on")
    hMixer_t mxp
) {
    // A concrete implementation can use `e_set_property` to tell the checker
    // that the postcondition has been established.
    e_set_property("blade", "on", mxp);
}

void get_ready(
    e_initialized()
    e_out("blade", "off")
    e_out("door", "closed")
    e_out("cable", "attached")
    hMixer_t mxp
) {
    mixer_off(mxp);
    mixer_attach_cable(mxp);
    mixer_close(mxp);
}

void ok_blend_cycle(hMixer_t e_uninitialized() mxp) {
    mixer_ctor(mxp);
    get_ready(mxp);

    mixer_on(mxp);
    mixer_off(mxp);
    mixer_open(mxp);
    mixer_detach_cable(mxp);
}

void ok_allocated_cycle(int id) {
    hMixer_t e_own mxp = alloc_mixer(id);
    ok_blend_cycle(mxp);
}

void bad_nominal_return(void) {
    Mixer_t mx = 42; // violation: `Mixer_t` is nominally distinct from `int`
    (void)mx;
}

void bad_start_while_open(hMixer_t e_initialized() mxp) {
    e_set_property("blade", "off", mxp);
    mixer_attach_cable(mxp);

    // violation: `mixer_on` requires the door to be closed
    mixer_on(mxp);
}

void bad_start_without_cable(hMixer_t e_initialized() mxp) {
    mixer_close(mxp);

    // violation: `mixer_on` requires the cable to be attached
    mixer_on(mxp);
}

void bad_borrow_conflict(Mixer_t mx) {
    const Mixer_t *read_ref = &mx;

    // violation: mutable access conflicts with the live immutable borrow
    Mixer_t *write_ref = &mx;

    inspect_mixer(read_ref);
    service_mixer(write_ref);
}

void bad_use_after_move(hMixer_t e_own mxp) {
    mixer_destroy(mxp);

    // violation: `mxp` was moved into `mixer_destroy`
    mixer_off(mxp);
}

void bad_move_stack_resource(void) {
    Mixer_t stack_mixer;
    hMixer_t e_own stack_handle = &stack_mixer;

    // violation: moving a stack-backed variable is not a valid ownership move
    mixer_destroy(stack_handle);
}

int main(int argc, char **argv) {
    int id = argc > 1 ? atoi(argv[1]) : 1;
    ok_allocated_cycle(id);
    return 0;
}
