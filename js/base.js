/* LC_NOTICE_BEGIN
LC_NOTICE_END */

// ================================================================
//                            MODULES
// ================================================================

// we need jQuery library
import "https://code.jquery.com/jquery-3.6.0.min.js"

$("body").append("ciao")

// ================================================================
//                             TMP
// ================================================================

function m_openAllDetails()
{
    $("details").attr('open', '');
}

function m_closeAllDetails()
{
    $('details').removeAttr('open');
}

// ================================================================
//                          LC - export
// ================================================================

var lc = {
    openAllDetails : m_openAllDetails,
    closeAllDetails : m_closeAllDetails
};

export { lc };