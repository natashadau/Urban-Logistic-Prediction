**Modeling Logic**

I selected the CatBoost Regressor as the model because it handles categorical variables, performs well with relatively small datasets, and is capable of capturing nonlinear interactions such as the combined effect of traffic and time of day. 

The initial configuration included 400 iterations, a learning rate of 0.05, tree depth of 8, and used RMSE as the main loss function since it reflects both average errors and bigger mistakes. 

To test the model properly, I split the data into 70% training, 15% validation, and 15% test. The validation set helped with tuning and early stopping, while the test set gave me a clean check on how well the model performs on unseen data.

**Metric choice**

To evaluate the model’s performance, I used three complementary metrics:

- MAE captures the average error in minutes, which makes it very easy to explain to the business since it tells us, on average, how far off the delivery time predictions are.
- RMSE puts more weight on larger mistakes, so it’s useful for checking whether the model is making big errors that might be hidden if only looked at MAE.
- P90 Error is focused on the "tail" of the distribution, showing the maximum error range that 90% of deliveries fall under. This is especially important in a logistics situation as the scenario, because customer dissatisfaction is usually driven by the worst delays rather than the average case.

**Tuning approach**

I first started with a baseline model using depth=8 and 1000 iterations. During training, I noticed that early stopping consistently was around ~243 iterations, which meant the model was converging much earlier and additional trees only increased the risk of overfitting. 

To explore further, I tested different tree depths. With depth=6, the model maintained stable MAE and RMSE but showed slightly worse performance on P90 error, meaning it struggled more with extreme delays. At depth=7, the results were very similar to depth=6, with no meaningful improvements. Going back to depth=8, the model struck the best balance, achieving solid overall accuracy while handling tail cases more effectively. 

Based on these findings, I set the final configuration to iterations=400, depth=8, learning_rate=0.05, and used early stopping to let the model pick its best iteration. I also dropped weak features like order_id and courier_experience to reduce noise and improve generalization.

