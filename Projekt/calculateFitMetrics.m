function [Jfit] = calculateFitMetrics(actualData, simulatedData)
    y = actualData;
    ym = simulatedData;
    m_y = sum(y)/length(y);
    my = ones(1, length(y))*m_y;

    Jfit = (1-norm(y-ym)/norm(y-my))*100;

   
    fprintf('Wskaźnik J_{fit}: %.2f%%\n', Jfit);
end