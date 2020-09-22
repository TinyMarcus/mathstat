function lab2()
    % Выборка объема n из генеральной совокупности X
    X = [-8.47,-7.45,-7.12,-8.30,-8.15,-6.01,-5.20,-7.38,-6.76,-9.18,-6.00,-8.08, ...
         -7.96,-8.34,-6.82,-8.46,-8.07,-7.04,-7.24,-8.16,-8.20,-8.27,-7.79,-7.37, ...
         -7.02,-7.13,-6.99,-7.65,-8.18,-6.71,-8.41,-6.71,-7.04,-9.15,-7.74,-10.11, ...
         -8.20,-7.07,-7.63,-8.99,-6.62,-6.23,-7.13,-6.41,-7.06,-7.72,-8.44,-8.85, ...
         -8.02,-6.98,-6.08,-7.20,-7.48,-7.82,-9.19,-8.31,-7.95,-7.97,-6.66,-6.59, ...
         -9.10,-7.87,-9.02,-8.77,-7.62,-9.44,-8.05,-7.60,-7.33,-6.94,-8.51,-7.39, ...
         -6.44,-8.88,-8.21,-7.66,-6.91,-8.39,-7.37,-7.26,-6.04,-7.58,-7.28,-7.02, ...
         -7.10,-7.33,-8.63,-8.21,-7.12,-8.11,-9.03,-8.11,-8.79,-9.22,-7.32,-5.97, ...
         -7.26,-6.39,-7.64,-8.38,-7.67,-7.70,-7.70,-8.95,-6.25,-8.09,-7.85,-8.10, ...
         -7.73,-6.78,-7.78,-8.20,-8.88,-8.51,-7.45,-7.14,-6.63,-7.38,-7.72,-6.25];
    
   % Поиск точечной оценки математичесого ожидания выборки
    m = mean(X);

    % Поиск точечной оценки дисперсии выборки
    d = CountD(X);
    
    gamma = 0.9;
    n = length(X);
    
    % Поиск нижней и верхней границ мат. ожидания выборки
    [m_low, m_high] = CountBordersM(m, d, gamma, n);
    
    % Поиск нижней и верхней границ дисперсии выборки
    [d_low, d_high] = CountBordersD(d, gamma, n);
    
    % Вывод найденных параметров
    fprintf('MX: %.3f\n', m);
    fprintf('DX: %.3f\n', d);
    fprintf('Границы мат. ожидания: (%.3f .. %.3f)\n', m_low, m_high);
    fprintf('Границы дисперсии: (%.3f .. %.3f)\n', d_low, d_high);

    % Отрисовка графиков
    DrawM(X, gamma, n);
    DrawD(X, gamma, n);
end

% Функция для вычисления оценки дисперсии выборки
function d = CountD(X)
    d = sum((X - mean(X)) .^ 2) / (length(X) - 1);
    return
end

% Функция для вычисления нижней и верхней границ математического ожидания
function [m_low, m_high] = CountBordersM(m, d, gamma, n)
    alpha = 1 - (1 - gamma) / 2;
    quant = tinv(alpha, n - 1);
    
    delta = quant * sqrt(d) / sqrt(n);
    
    m_low = m - delta;
    m_high = m + delta;
end
   
% Функция для вычисления нижней и верхней границ дисперсии
function [d_low, d_high] = CountBordersD(d, gamma, n)    
    low = (1 - gamma) / 2;
    quant = chi2inv(low, n - 1);
    d_high = d * (n-1) / quant;
    
    high = 1 - low;
    quant = chi2inv(high, n - 1);
    d_low = d * (n-1) / quant;
end

% Функция для отрисовки графиков функций, связанных с мат. ожиданием
function DrawM(X, gamma, n)
    subplot(2, 1, 1);
    
    start = 5;
    
    m = zeros(n, 1);
    d = zeros(n, 1);
    m_line = zeros(n, 1);
    m_low = zeros(n, 1);
    m_high = zeros(n, 1);
    
    for i = 1:n
        seg = X(1:i);
        m(i) = mean(seg);
        d(i) = CountD(seg);
    end

    m_line(1:n) = m(n);
    
    for i = 1:n
        [m_low(i), m_high(i)] = CountBordersM(m(i), d(i), gamma, i);
    end
    
    hold on;
    plot((start:n), m_line(start:n), 'r');
    plot((start:n), m(start:n), 'g');
    plot((start:n), m_high(start:n), 'b');
    plot((start:n), m_low(start:n), 'k');
    hold off;
    
    xlabel('n');
    ylabel('\mu');
    leg = legend('$\hat {\mu} (x_N)$', '$\hat {\mu} (x_n)$', ...
                  '$\overline {\mu} (x_n)$', '$\underline {\mu} (x_n)$');             
    set(leg, 'Interpreter', 'latex');
end

% Функция для отрисовки графиков функций, связанных с дисперсией
function DrawD(X, gamma, n)
    subplot(2, 1, 2);
    
    start = 5;
    
    m = zeros(n, 1);
    d = zeros(n, 1);
    d_line = zeros(n, 1);
    d_low = zeros(n, 1);
    d_high = zeros(n, 1);
    
    for i = 1:n
        seg = X(1:i);
        m(i) = mean(seg);
        d(i) = CountD(seg);
    end

    d_line(1:n) = d(n);
    
    for i = 1:n
        [d_low(i), d_high(i)] = CountBordersD(d(i), gamma, i);
    end
    
    hold on;
    plot((start:n), d_line(start:n), 'r');
    plot((start:n), d(start:n), 'g');
    plot((start:n), d_high(start:n), 'b');
    plot((start:n), d_low(start:n), 'k');
    hold off;
    
    xlabel('n');
    ylabel('\sigma');
    leg = legend('$S^2(x_N)$', '$S^2(x_n)$', ...
                  '$\overline {\sigma}^2 (x_n)$', '$\underline {\sigma}^2 (x_n)$');             
    set(leg, 'Interpreter', 'latex');
end