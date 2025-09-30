**Model Failure**

The first step would be to improve the data before changing the model itself. Currently, rainy is a very broad category, so we should collect richer weather data such as rainfall intensity, storm alerts, or duration of rain, and create new features that combine weather with other factors like traffic, distance, or vehicle type. This would give the model more context to adjust its predictions. Then I would adjust hyperparameters and retrain the model to see if the errors on rainy days decrease.

On the business side, communication with customers during rainy conditions could be helpful. For example, showing a wider ETA range on rainy days instead of a single number, and notifying operations to increase courier supply or prioritize faster vehicles like scooters or cars when the weather is bad. This way, even if the model isn’t performing at its peak yet, expectations are managed and operations are better prepared.

**Transferability**

I would start collecting reliable local data in São Paulo for the same core features used in Mumbai. Then analysing adding new features may also be necessary to reflect São Paulo’s context, for example, unique rush-hour schedules, more frequent rainfall events, or differences in courier availability across neighborhoods. Once this data is ready, the Mumbai model is tested directly on São Paulo deliveries to measure performance. Depending on results, the strategy can be to retrain fully on São Paulo data, fine-tune the Mumbai model using São Paulo examples, or train a model combining both datasets for robustness.

On the business side, the Ops teams should be informed and actively involved, so they can flag inaccurate predictions and provide on-the-ground feedback. During the early phase, it is especially important to track error metrics by region and by condition. 

**GenAI Disclosure**

I used GenAI tools as a support resource to speed up development. I relied on it to refine and debug code, which helped me quickly identify errors and improve my scripts. I also used it to compare potential modeling approaches, evaluating which algorithms might be the best fit for the delivery time prediction problem. During the fine-tuning stage, GenAI supported me in interpreting metrics and comparing model results, making it easier to decide which configuration offered the best balance of accuracy and robustness.

I also used GenAI to generate dummy datasets for testing and validation of SQL queries, which allowed me to check database logic before running it on real data.

**Your Signature Insight**

One of the parts I enjoyed most in developing the assessment was the Exploratory Data Analysis, where I uncovered insights about inefficiencies in vehicle assignment. The analysis showed that bikes were sometimes allocated to very long trips, over 15 km, which consistently resulted in extreme delays and many customer complaints. This pattern was not obvious at the beginning because distance and traffic alone seemed to be the main drivers of delays. However, the model revealed that it is not only the distance itself, but the mismatch between distance and vehicle type, that creates the most problematic outliers.

This finding highlights an opportunity to enhance operations by introducing an order-vehicle assignment check before dispatch. Such a system could flag orders where the distance is too long for a bike or scooter and recommend assigning a faster vehicle instead. Finally, it is important to note that solving this issue requires not only a logistical enhancement supported by the model, but also an operational optimization to address inefficiencies in restaurant preparation times. Both areas must work together to reduce delays in a sustainable way.

**Going to Production**

These are the main steps and components I would implement:

- Model Packaging
    - Export the trained CatBoost model (.cbm format).
    - Wrap it in a prediction service (like Python FastAPI or Flask app) that exposes an endpoint such as /predict_delivery_time.
    - The service accepts the features and returns both a predicted ETA.
    - Containerize with Docker to make it portable and deployable on cloud services.


- Data Pipeline Integration
    - Ensure real-time order data like distance, weather and traffic is passed to the API.
    - Add checks for missing or invalid values.
    - Store inputs and predictions for later auditing and retraining.


- Alerts and Monitoring
    - Track live metrics: MAE, RMSE, and especially P90 error on recent batches.
    - Add alerts if performance drifts, for example rainy-day P90 error exceeds a threshold.


- Model Lifecycle
    - Automate retraining on new data
    - Promote models that outperform the current production baseline.


