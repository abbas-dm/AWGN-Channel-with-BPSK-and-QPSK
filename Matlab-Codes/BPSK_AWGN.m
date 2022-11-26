clc;
close all;
clear;

% Reading the Image from the folder
myfiles = dir('C:\Users\JAHEER ABBAS\Documents\MATLAB\Images\*.jpeg');
num = length(myfiles);

for i = 1:num
    image_name = strcat('C:\Users\JAHEER ABBAS\Documents\MATLAB\Images\', myfiles(i).name);
    A = imread(image_name);
    
    % Generating Binary image and visualizing the binary image
    BW = imbinarize(A);
    sw = size(BW);
    figure;
    image(BW);
    title("Original Binary Image");
    
    % Converting the binary image data into a column vector
    C = BW(:);
    C = C';
    
    % Initializing SNRdb vals to compare with BER
    SNRdb = -8:1:12;
    SNR = 10.^(SNRdb/10);
    
    % This is the some random vector used a noise 
    n = randn(1, length(C));
    
    % BPSK modulation data from the binary image data
    BPSK = 1 - 2*C;
    
    for k = 1:length(SNR)
        y = (sqrt(SNR(k))*BPSK) + n;    % n is AWGN noise
    
        % Finding No of currupted bits
        noisy_bits = y.*BPSK;
        indicies_currupted = find((noisy_bits)<0);
        NumofCurrupted(k) = length(find(indicies_currupted));
    
        for r = 1:length(y)
            if y(r) < 0
                binary(r) = 1;
            elseif y(r) >= 0
                binary(r) = 0;
            end
        end
        mse(k) = immse(binary, double(C));
    end
    
    % Calculating BER = No_of_currupted_bits / Total_no_of_bits
    ber = NumofCurrupted/length(C);
    
    figure;
    
    % Matlab code output
    % Practical
    prac = semilogy(SNRdb, ber, 'b*-', 'LineWidth', 1);
    hold on
    
    % Using the Q function, calculate the QPSK error probability,
    % Pb = sqrt(2*(Eb/N0))
    % Theoritical
    theory = qfunc(sqrt(SNR));
    theo = semilogy(SNRdb, theory, 'r+-', 'LineWidth', 1);
    
    % Plotting the BER vs SNRdb plot
    xlabel("SNR in dbs");
    ylabel("BER Bits Error Rate");
    legend([prac, theo], {'Practical', 'Theoaritical'});
    title("BER vs SNR");
    
    figure;
    % Plotting the MSE vs SNRdb plot
    prac = semilogy(SNRdb, mse, 'r*-', 'LineWidth', 1);
    xlabel("SNR in dbs");
    ylabel("MSE Mean Square Error");
    title("MSE vs SNR");
    
    % Constructing back the manupilated data into 
    % binary data with threshold as '0'
    for l = 1:length(y)
        if y(l) < 0
            y(l) = 1;
        elseif y(l) > 0
            y(l) = 0;
        end
    end
    
    % Reshaping back to visualize the binary image
    X = reshape(y,[sw(1), sw(2), sw(3)]);
    figure;
    image(X);
    title("Reconstructed Binary Image");

    % Clearing all the data variables except folder path
    % and count of files in that folder
    clearvars -except myfiles num;
end

