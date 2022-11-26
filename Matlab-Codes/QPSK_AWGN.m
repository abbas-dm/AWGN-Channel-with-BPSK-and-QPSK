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
    BW = interp1([0,255],[0,3],double(A));
    sw = size(BW);
    figure;
    image(BW);
    title("Original Quatriple Image");
        
    % Converting the binary image data into a column vector
    C = int16(BW(:));
        
    % Initializing SNRdb vals to compare with BER
    SNRdb = 0:1:20;
    SNR = 10.^(SNRdb/10);
    
    % For QPSK modulation
    QPSK = pskmod(double(C), 4);   

    l = length(QPSK);
    QPSK = QPSK';

    for k = 1:length(SNR)

        % AWNG Noise
        w=(1/sqrt(2*SNR(k)))*(randn(1,l)+1i*randn(1,l));  
        y = QPSK + w;

        si_=sign(real(y));                                %In-phase demodulation
        sq_=sign(imag(y));                                %Quadrature demodulation
        ber1=(l-sum(sign(real(QPSK))==si_))/l;            %In-phase BER calculation
        ber2=(l-sum(sign(imag(QPSK))==sq_))/l;            %Quadrature BER calculation
        ber(k)=mean([ber1 ber2]);                         %Overall BER
    end
    
    figure;
    
    % Matlab code output
    % Practical
    semilogy(SNRdb, ber, 'b*-', 'LineWidth', 1);
    grid on;
    xlabel("SNR in dbs");
    ylabel("BER Bits Error Rate");
    title("BER vs SNR");

    % demodulation of resulted image data
    deQPSK = pskdemod(y, 4);

    % Reshaping the data to visualize in the form of Image
    X = reshape(deQPSK,[sw(1), sw(2), sw(3)]);
    figure;
    image(X);
    title("Reconstructed Image");

    % Clearing all the data variables except folder path
    % and count of files in that folder
    clearvars -except myfiles num;
end