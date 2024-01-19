import pandas as pd
import random
from flask import Flask, jsonify
from flask_cors import CORS

import schedule
import time
import datetime

app = Flask(__name__)
CORS(app)


cols = ['Dish', 'Calories', 'Meal_Type']
data = pd.read_csv('sample1.csv', names=cols)
df = pd.DataFrame(data)

current_recommendation = None
last_generation_time = None


def generate_recommendation():
    global current_recommendation, last_generation_time
    trimister = 'trimister one'  

    dryfruit_dishes = df.loc[(df['Meal_Type'] == 'dryfruits') & (df['Calories'] >= 20) & (df['Calories'] <= 50), 'Dish']
    seeds_dishes = df.loc[(df['Meal_Type'] == 'seeds') & (df['Calories'] == 20), 'Dish']
    egg_dishes = df.loc[(df['Meal_Type'] == 'Egg') & (df['Calories'] >= 70) & (df['Calories'] <= 90), 'Dish']
    breakfast_dishes = df.loc[(df['Meal_Type'] == 'breakfast') & (df['Calories'] >= 175) & (df['Calories'] <= 275), 'Dish']
    snack1_dishes = df.loc[(df['Meal_Type'] == 'snack1') & (df['Calories'] >= 40) & (df['Calories'] <= 180), 'Dish']
    lunch_dishes = df.loc[(df['Meal_Type'] == 'lunch') & (df['Calories'] >= 270) & (df['Calories'] <= 470), 'Dish']
    curd_dishes = df.loc[(df['Meal_Type'] == 'curd') & (df['Calories'] == 260), 'Dish']
    snack2_dishes = df.loc[(df['Meal_Type'] == 'snack2') & (df['Calories'] >= 95) & (df['Calories'] <= 200), 'Dish']
    dinner_dishes = df.loc[(df['Meal_Type'] == 'Dinner') & (df['Calories'] >= 170) & (df['Calories'] <= 310), 'Dish']
    milk_dishes = df.loc[(df['Meal_Type'] == 'milk') & (df['Calories'] == 110), 'Dish']
    # Similar logic for other meal types...

    drd = dryfruit_dishes.tolist()
    sd = seeds_dishes.tolist()
    ed = egg_dishes.tolist()
    bd = breakfast_dishes.tolist()
    s1d = snack1_dishes.tolist()
    ld = lunch_dishes.tolist()
    cd = curd_dishes.tolist()
    s2d = snack2_dishes.tolist()
    dd = dinner_dishes.tolist()
    md = milk_dishes.tolist()


    Dryfruits = random.choice(drd)
    Seed = random.choice(sd)
    Egg = random.choice(ed)
    Breakfast = random.choice(bd)
    Snack1 = random.choice(s1d)
    Lunch = random.choice(ld)
    Curd = random.choice(cd)
    Snack2 = random.choice(s2d)
    Dinner = random.choice(dd)
    Milk = random.choice(md)


    # Calculate the total calories
    d1 = df.loc[df['Dish'] == Dryfruits, 'Calories'].tolist()
    d2 = df.loc[df['Dish'] == Seed, 'Calories'].tolist()
    d3 = df.loc[df['Dish'] == Egg, 'Calories'].tolist()
    d4 = df.loc[df['Dish'] == Breakfast, 'Calories'].tolist()
    d5 = df.loc[df['Dish'] == Snack1, 'Calories'].tolist()
    d6 = df.loc[df['Dish'] == Lunch, 'Calories'].tolist()
    d7 = df.loc[df['Dish'] == Curd, 'Calories'].tolist()
    d8 = df.loc[df['Dish'] == Snack2, 'Calories'].tolist()
    d9 = df.loc[df['Dish'] == Dinner, 'Calories'].tolist()
    d10 = df.loc[df['Dish'] == Milk, 'Calories'].tolist()

    total_calories = [d1[0] + d2[0] + d3[0] + d4[0] + d5[0] + d6[0] + d7[0] + d8[0] + d9[0] + d10[0]]
    res = True
    for ele in total_calories:
        if trimister == 'trimister one':
            if ele < 1750 or ele >= 1900:
                res = False
                break
        if trimister == 'trimister two':
            if ele < 2050 or ele >= 2150:
                res = False
                break
        if trimister == 'trimister three':
            if ele < 2200 or ele >= 2400:
                res = False
                break

    # Define the recommended diet
    if res:
        recommendation = {
            'Trimister': trimister,
            'Dryfruits': Dryfruits,
            'Seeds': Seed,
            'Egg': Egg,
            'Breakfast': Breakfast,
            'Morning Snacks': Snack1,
            'Lunch': Lunch,
            'Curd': Curd,
            'Evening Snacks': Snack2,
            'Dinner': Dinner,
            'Milk': Milk,
            'Total_Calories': total_calories
        }
    else:
        return generate_recommendation()

    # Store the recommendation and the generation time
    current_recommendation = recommendation
    last_generation_time = datetime.datetime.now()

# Schedule the recommendations to be generated daily
schedule.every(1).days.at("00:00").do(generate_recommendation)

# Initial generation
generate_recommendation()

# Function to get the current recommendation
def get_current_recommendation():
    global current_recommendation, last_generation_time
    current_time = datetime.datetime.now()
    # Check if 24 hours have passed since the last generation
    if (current_time - last_generation_time).total_seconds() >= 24 * 60 * 60:
        generate_recommendation()  # Regenerate the recommendation
    return current_recommendation

@app.route('/')
def recommend_dishes():
    recommendation = get_current_recommendation()
    return jsonify(recommendation)

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
    
    while True:
        schedule.run_pending()
        time.sleep(1)
