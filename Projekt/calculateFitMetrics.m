function [msePercentage, correlationPercentage, curveSimilarity] = calculateFitMetrics(actualData, simulatedData)
    % Obliczanie błędu średniokwadratowego (MSE)
    squaredError = (actualData - simulatedData).^2;
    mse = mean(squaredError);

    % Obliczanie korelacji
    correlation = corrcoef(actualData, simulatedData);
    correlation = correlation(1, 2);


    % Obliczanie analizy podobieństwa krzywych (na podstawie Odległości euklidesowej)
    euclideanDistance = norm(actualData - simulatedData);
    curveSimilarity = 100 - euclideanDistance;

    % Konwersja na procenty
    msePercentage = 100 - mse * 100;
    correlationPercentage = correlation * 100;

    Jfit = (msePercentage + correlationPercentage + curveSimilarity)/3;

    % Wyświetlanie wyników
    fprintf('MSE: %.2f%%\n', msePercentage);
    fprintf('Korelacja: %.2f%%\n', correlationPercentage);
    fprintf('Podobieństwo krzywych: %.2f%%\n', curveSimilarity);
    fprintf('Wskaźnik J_{fit}: %.2f%%\n', Jfit);
end