**Exploratory Data Analysis**

Delivery times in a food delivery platform depend on multiple factors:
- External: traffic, weather, time of day.
- Operational: restaurant preparation time, courier experience.
- Logistics: distance and vehicle type.

This EDA explores which variables have the greatest impact on delivery time, identifying risks, inefficiencies, and potential optimizations.


```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```


```python
df = pd.read_csv('Food_Delivery_Times.csv')
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 1000 entries, 0 to 999
    Data columns (total 9 columns):
     #   Column                  Non-Null Count  Dtype  
    ---  ------                  --------------  -----  
     0   Order_ID                1000 non-null   int64  
     1   Distance_km             1000 non-null   float64
     2   Weather                 970 non-null    object 
     3   Traffic_Level           970 non-null    object 
     4   Time_of_Day             970 non-null    object 
     5   Vehicle_Type            1000 non-null   object 
     6   Preparation_Time_min    1000 non-null   int64  
     7   Courier_Experience_yrs  970 non-null    float64
     8   Delivery_Time_min       1000 non-null   int64  
    dtypes: float64(2), int64(3), object(4)
    memory usage: 70.4+ KB
    


```python
df.columns = [col.lower() for col in df.columns]
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>order_id</th>
      <th>distance_km</th>
      <th>weather</th>
      <th>traffic_level</th>
      <th>time_of_day</th>
      <th>vehicle_type</th>
      <th>preparation_time_min</th>
      <th>courier_experience_yrs</th>
      <th>delivery_time_min</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>522</td>
      <td>7.93</td>
      <td>Windy</td>
      <td>Low</td>
      <td>Afternoon</td>
      <td>Scooter</td>
      <td>12</td>
      <td>1.0</td>
      <td>43</td>
    </tr>
    <tr>
      <th>1</th>
      <td>738</td>
      <td>16.42</td>
      <td>Clear</td>
      <td>Medium</td>
      <td>Evening</td>
      <td>Bike</td>
      <td>20</td>
      <td>2.0</td>
      <td>84</td>
    </tr>
    <tr>
      <th>2</th>
      <td>741</td>
      <td>9.52</td>
      <td>Foggy</td>
      <td>Low</td>
      <td>Night</td>
      <td>Scooter</td>
      <td>28</td>
      <td>1.0</td>
      <td>59</td>
    </tr>
    <tr>
      <th>3</th>
      <td>661</td>
      <td>7.44</td>
      <td>Rainy</td>
      <td>Medium</td>
      <td>Afternoon</td>
      <td>Scooter</td>
      <td>5</td>
      <td>1.0</td>
      <td>37</td>
    </tr>
    <tr>
      <th>4</th>
      <td>412</td>
      <td>19.03</td>
      <td>Clear</td>
      <td>Low</td>
      <td>Morning</td>
      <td>Bike</td>
      <td>16</td>
      <td>5.0</td>
      <td>68</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.isnull().sum()
```




    order_id                   0
    distance_km                0
    weather                   30
    traffic_level             30
    time_of_day               30
    vehicle_type               0
    preparation_time_min       0
    courier_experience_yrs    30
    delivery_time_min          0
    dtype: int64



**1. Target Variable: Delivery time distribution**


```python
plt.figure(figsize=(8,5))
sns.histplot(df['delivery_time_min'], kde=True, bins=30, color="skyblue")
plt.title("Distribución de Delivery Time (min)", fontsize=14)
plt.xlabel("Delivery Time (min)")
plt.ylabel("Frecuencia")
plt.show()
```


    
<img width="699" height="472" alt="output_7_0" src="https://github.com/user-attachments/assets/b30a74da-1654-4065-9ab0-817c52e73d9b" />

    


**Key insights:**

- The distribution is right-skewed: most deliveries occur between 40–70 minutes.
- There is a long tail with extreme values >120 min → likely traffic jams, bad weather, or operational failures.
- The mode is around 50–55 minutes, which seems to be the “typical” delivery time.
- Outliers are critical: although complaints exist, the majority of deliveries are within expected standards (<70 min).

**2. Distance vs Delivery Time**


```python
plt.figure(figsize=(8,5))
sns.scatterplot(x="distance_km", y="delivery_time_min", data=df, alpha=0.6)
plt.title("Distancia (km) vs Tiempo de Entrega (min)", fontsize=14)
plt.xlabel("Distance (km)")
plt.ylabel("Delivery Time (min)")
plt.show()
```


    
<img width="695" height="471" alt="output_10_0" src="https://github.com/user-attachments/assets/9e3709e6-f958-4f79-92be-2c537c5706ad" />

    


**Key insights:**

- Strong positive relationship → longer distance = longer delivery time.
- At short distances (<5 km) delivery times vary widely (15–80 min) → showing that traffic, weather, or preparation time also play a role.
- At long distances (>15 km) delivery times concentrate at 70–120 min.
- Outliers: some short trips take over 100 min → clear cases of operational issues.

**3. Traffic Level vs Delivery Time**


```python
plt.figure(figsize=(8,5))
sns.boxplot(x="traffic_level", y="delivery_time_min", hue="traffic_level",
            data=df, palette="Set2", legend=False)
plt.title("Nivel de Tráfico vs Tiempo de Entrega", fontsize=14)
plt.xlabel("Traffic Level")
plt.ylabel("Delivery Time (min)")
plt.show()

```


    
<img width="695" height="472" alt="output_13_0" src="https://github.com/user-attachments/assets/fdabeca5-7caa-4ab7-b3e8-f47a8be98e04" />

    


**Key insights:**

- Median delivery times increase steadily:
- Low ~45 min, Medium ~55 min, High ~65 min.
- High traffic = much larger variability, ranging from 20 to 120+ min.
- Even under low traffic, there are very long deliveries → confirming that traffic is not the only cause of delays.

**4. Weather vs Delivery Time**


```python
plt.figure(figsize=(9,5))
sns.boxplot(x="weather", y="delivery_time_min", hue="weather",
            data=df, palette="Set3", legend=False)
plt.title("Clima vs Tiempo de Entrega", fontsize=14)
plt.xlabel("Weather Condition")
plt.ylabel("Delivery Time (min)")
plt.show()
```


<img width="773" height="471" alt="output_16_0" src="https://github.com/user-attachments/assets/1ff3500e-7ec0-49ee-90aa-37636838fd46" />

    


**Key insights:**

- Clear weather = baseline (~50 min).
- Rainy/Foggy = slightly higher median (~55–60 min).
- Snowy = worst-case scenario (~65 min, with several outliers >120).
- Weather does affect delivery times, but the impact is only drastic in extreme conditions.

**5. Vehicle Type vs Delivery Time**


```python
plt.figure(figsize=(8,5))
sns.boxplot(x="vehicle_type", y="delivery_time_min", hue="vehicle_type",
            data=df, palette="Pastel1", legend=False)
plt.title("Tipo de Vehículo vs Tiempo de Entrega", fontsize=14)
plt.xlabel("Vehicle Type")
plt.ylabel("Delivery Time (min)")
plt.show()
```


    
<img width="695" height="472" alt="output_19_0" src="https://github.com/user-attachments/assets/f211587d-5c89-4f1c-a493-c8a3ea729b01" />

    


**Key insights:**

- Scooters: lowest median (~50 min).
- Bikes: slightly slower (~55–60 min).
- Cars: slightly higher (~60 min) and more high-end outliers → less efficient in congested urban areas.
- All vehicles show wide variability → delays depend also on distance, traffic, and weather.

**6. Correlation Between Numeric Variables**


```python
plt.figure(figsize=(7,5))
sns.heatmap(df[["distance_km","preparation_time_min","courier_experience_yrs","delivery_time_min"]].corr(),
            annot=True, cmap="Blues", fmt=".2f")
plt.title("Correlación entre variables numéricas")
plt.show()
```


    
<img width="702" height="597" alt="output_22_0" src="https://github.com/user-attachments/assets/5d123e9e-8fc8-457b-a758-8492e1e1f510" />

    


**Key insights:**

- Distance_km strongly correlates with delivery time (0.78) → main predictor.
- Preparation_time_min moderately correlates (0.31) → internal operations matter.
- Courier_experience_yrs has almost no impact → delays are more structural than individual.

**7. Distance by Vehicle Type**


```python
groups = [g["distance_km"].dropna().values for _, g in df.groupby("vehicle_type")]
labels = [str(k) for k,_ in df.groupby("vehicle_type")]

plt.figure(figsize=(8,5))
plt.boxplot(groups, tick_labels=labels, showfliers=True)
plt.title("Distance (km) by Vehicle Type")
plt.xlabel("Vehicle Type")
plt.ylabel("Distance (km)")
plt.show()

```

    C:\Users\natas\AppData\Local\Temp\ipykernel_13328\1466883826.py:5: MatplotlibDeprecationWarning: The 'labels' parameter of boxplot() has been renamed 'tick_labels' since Matplotlib 3.9; support for the old name will be dropped in 3.11.
      plt.boxplot(groups, labels=labels, showfliers=True)
    


    
<img width="700" height="470" alt="output_25_1" src="https://github.com/user-attachments/assets/87e6b6c1-57f9-4292-bed2-5747b5b8c17e" />

    


Key insights:

- All vehicles have a median distance ~10 km.
- Long trips (>18 km) exist even for bikes → not efficient and likely to cause complaints.
- Suggestion:
    - Bikes <7 km
    - Scooters 7–12 km
    - Cars >12 km

**8. Distance by Time of Day**


```python
groups = [g["distance_km"].dropna().values for _, g in df.groupby("time_of_day")]
labels = [str(k) for k,_ in df.groupby("time_of_day")]

plt.figure(figsize=(8,5))
plt.boxplot(groups, tick_labels=labels, showfliers=True)
plt.title("Distance (km) by Time of Day")
plt.xlabel("Time of Day")
plt.ylabel("Distance (km)")
plt.show()
```


    
<img width="700" height="470" alt="output_28_0" src="https://github.com/user-attachments/assets/fe5aca5c-01e0-4711-b95a-f08b777e8e74" />



**Key insights:**

- Median distance remains stable (~10 km) across all time slots.
- Delays at specific times of day are not due to longer trips, but rather traffic congestion and workload distribution.

**9. Distance by Time of Day & Vehicle Type**


```python
plt.figure(figsize=(10,6))
sns.boxplot(x="time_of_day", y="distance_km", hue="vehicle_type", data=df)
plt.title("Distance by Time of Day & Vehicle Type")
plt.xlabel("Time of Day")
plt.ylabel("Distance (km)")
plt.legend(title="Vehicle Type")
plt.show()
```


    
<img width="855" height="547" alt="output_31_0" src="https://github.com/user-attachments/assets/0301e319-5137-46df-9e89-1c62f8953402" />

    


**Key insights:**

- Cars handle the longest trips in all time slots.
- Bikes are used even for long trips (>18 km), which is inefficient.
- Scooters are intermediate but more consistent than cars.
- Outliers in bikes + long trips likely explain many customer complaints.

**Summary**

**Key Patterns**

- Delivery time is strongly correlated with distance, and also rises steadily with traffic level and adverse weather conditions.
- Most deliveries occur within 50–70 minutes, making this the operational norm.
- Scooters are generally the fastest and most consistent, while cars face more congestion-related delays.
- Preparation time contributes moderately, while courier experience shows little direct effect.

**Outliers**

- A subset of deliveries exceeds 120 minutes, even under short distances or low traffic.
- Bikes assigned to long trips (>15 km) are a recurring inefficiency leading to excessive delays.
- Extreme weather (especially snow) produces the longest and most variable delivery times.

**Assumptions**

- Reported delivery times and categorical labels (traffic, weather) are accurate and consistently measured.
- Outliers represent real operational issues, not data entry errors.
- Customer expectations are aligned with the 50–70 minute delivery window as the standard baseline.
