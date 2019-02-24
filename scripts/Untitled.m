N = 200;
c = 100;
epsylon = 0.1;
charge = epsylon + epsylon * 1 * rand(N,N);
imagesc(charge);
img = zeros(N,N);

for t = 0 : 1000000
    charge(1,1) = 0.01;
    for x = 1:N-1
        for y = 1:N-1
            if (abs(charge(x,y) - charge(x+1,y)) > epsylon/(1+c*img(x,y)))
                charge(x+1,y) = (charge(x,y)+charge(x+1,y))/2;
                charge(x,y) = charge(x+1,y);
                img(x,y) = img(x,y)+1;
            end
            if (abs(charge(x,y) - charge(x,y+1)) > epsylon/(1+c*img(x,y)))
                charge(x,y+1) = (charge(x,y)+charge(x,y+1))/2;
                charge(x,y) = charge(x,y+1);
                img(x,y) = img(x,y)+1;
            end
            if (abs(charge(x,y) - charge(x+1,y+1)) > epsylon/(1+c*img(x,y))*sqrt(2))
                charge(x+1,y+1) = (charge(x,y)+charge(x+1,y+1))/2;
                charge(x,y) = charge(x+1,y+1);
                img(x,y) = img(x,y)+1;
            end
        end
    end
    if mod(t,500) == 0
    t
    pause(0.01);
    imagesc(log(img+1));
    end
end

imagesc(charge);
imagesc(img);