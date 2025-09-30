**Error Insights**

The model errors are related to:

- Short trips, of about distances of <5 km, with long delays of 80–100 min could be underestimated, usually caused by restaurant bottlenecks, courier availability issues, or traffic incidents not captured in the data.

- Larger errors arise in cases like unusual weather events or long trips assigned to slower vehicles, where the model has fewer examples to learn from.

- The model does not account for holidays or special events, when delivery behavior differs significantly from normal patterns.

- Operational noise has an influence, unpredictable disruptions such as courier reassignments or customers being unavailable also create errors the model cannot anticipate.
