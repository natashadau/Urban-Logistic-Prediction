**Explainability of the Model**

The feature importance analysis shows that distance is by far the most important driver of delivery time, accounting for more than half of the model’s predictive power. This confirms that the farther the delivery, the longer it takes, and highlights distance as the baseline determinant of performance. 

The second most important factor is preparation time, reflecting the influence of restaurant operations on delays. Traffic level and weather come next, with moderate impact, mainly explaining variability around the baseline. Finally, time of day and vehicle type contribute less overall but are still useful in edge cases, such as rush-hour traffic or long trips assigned to slower vehicles.

![Feature Importance Bar Graph](feature_importance_graph.png)

As presented in the graph, the model confirms that distance and preparation time are the dominant levers, while traffic, weather, and operational conditions help explain fluctuations and extreme delays.
