clear; clc;

% Secuencia de bits
bits = [1 0 0 1 0 0 0 0 1 1 1 1 0 1 1];

% Parámetros de la señal
Tb = 0.5;               % Duración de un bit
fs = 1000;              % Frecuencia de muestreo
f0 = 2;                 % Frecuencia de la portadora 0
f1 = 4;                 % Frecuencia de la portadora 1
alpha = 0.5;            % Factor de roll-off para GFSK

% Crear el tiempo de la señal
t = 0:1/fs:length(bits)*Tb-1/fs;

% Generar señal NRZ unipolar
signal_NRZ = [];
for i = 1:length(bits)
    if bits(i) == 1
        signal_NRZ = [signal_NRZ ones(1, fs*Tb)];
    else
        signal_NRZ = [signal_NRZ zeros(1, fs*Tb)];
    end
end

% Modulación FSK
signal_FSK = [];
for i = 1:length(bits)
    if bits(i) == 1
        signal_FSK = [signal_FSK sin(2*pi*f1*t(1:fs*Tb))];
    else
        signal_FSK = [signal_FSK sin(2*pi*f0*t(1:fs*Tb))];
    end
end

% Modulación GFSK
signal_GFSK = [];
for i = 1:length(bits)
    if bits(i) == 1
        phase = cumsum(2*pi*f1*ones(1, fs*Tb)/fs);
    else
        phase = cumsum(2*pi*f0*ones(1, fs*Tb)/fs);
    end
    signal_GFSK = [signal_GFSK exp(1j*phase)];
end
signal_GFSK = real(signal_GFSK);

% Graficar las señales
figure;

subplot(5,1,1);
plot(t, signal_NRZ);
title('Señal NRZ Unipolar (En el transmisor)');
xlabel('Tiempo');
ylabel('Amplitud');
ylim([-0.1 1.1]);

subplot(5,1,2);
plot(t, signal_FSK);
title('Señal Modulada FSK (En el transmisor)');
xlabel('Tiempo');
ylabel('Amplitud');

subplot(5,1,3);
plot(t, signal_GFSK);
title('Señal Modulada GFSK (En el transmisor)');
xlabel('Tiempo');
ylabel('Amplitud');

% Demodulación GFSK en el receptor
threshold = (f0 + f1) / 2; % Umbral para comparar energías
received_bits_GFSK = zeros(1, length(bits));

for i = 1:length(bits)
    % Calcular la energía en la frecuencia f0
    energy_f0 = sum(signal_GFSK((i-1)*fs*Tb+1:i*fs*Tb) .* sin(2*pi*f0*t(1:fs*Tb))) / (fs*Tb);
    % Calcular la energía en la frecuencia f1
    energy_f1 = sum(signal_GFSK((i-1)*fs*Tb+1:i*fs*Tb) .* sin(2*pi*f1*t(1:fs*Tb))) / (fs*Tb);

    % Comparar las energías (inversión)
    if energy_f1 < energy_f0
        received_bits_GFSK(i) = 1;
    else
        received_bits_GFSK(i) = 0;
    end
end

% Crear el vector de tiempo discreto para la secuencia de bits demodulada
t_bits = linspace(0, length(bits)*Tb, length(bits)+1);
t_bits(end) = [];

% Graficar la señal binaria (Demodulada)
subplot(5,1,4);
stairs(t_bits, received_bits_GFSK);
title('Señal Binaria (Demodulada)');
xlabel('Tiempo');
ylabel('Amplitud');
ylim([-0.1 1.1]);

% Imprimir la trama de bits obtenida en el receptor
disp('Trama de bits obtenida en el receptor:');
disp(received_bits_GFSK);