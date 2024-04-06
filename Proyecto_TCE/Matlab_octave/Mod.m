% Secuencia de bits
bits = [1 0 0 1 0 0 0 0 1 1 1 1 0 1 1];

% Parámetros de la señal
Tb = 0.5;                 % Duración de un bit
fs = 1000;                % Frecuencia de muestreo
f0 = 2;                   % Frecuencia de la portadora 0
f1 = 4;                   % Frecuencia de la portadora 1
alpha = 0.5;              % Factor de roll-off para GFSK

% Iniciar el contador de tiempo
tic;

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

% Detener el contador de tiempo y mostrar el tiempo de ejecución
toc;

% Graficar las señales
subplot(3,1,1);
plot(t, signal_NRZ);
title('Señal NRZ Unipolar');
xlabel('Tiempo');
ylabel('Amplitud');
ylim([-0.1 1.1]);

subplot(3,1,2);
plot(t, signal_FSK);
title('Señal Modulada FSK');
xlabel('Tiempo');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, signal_GFSK);
title('Señal Modulada GFSK');
xlabel('Tiempo');
ylabel('Amplitud');