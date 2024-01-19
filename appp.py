from flask import Flask, render_template, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
import pandas as pd
from sklearn.neighbors import BallTree
from geopy.geocoders import Nominatim
import geopy.distance

# Load the hospital data from the CSV file
hospital_data = pd.read_csv('Answer.csv')

# Convert the latitude and longitude columns to radians (for distance calculation)
hospital_data['latitude'] = hospital_data['latitude'].apply(lambda x: x * 3.14159265358979323846 / 180.0)
hospital_data['longitude'] = hospital_data['longitude'].apply(lambda x: x * 3.14159265358979323846 / 180.0)

# Initialize the BallTree for nearest neighbor search
X = hospital_data[['latitude', 'longitude']].values
ball_tree = BallTree(X, leaf_size=40, metric='haversine')

# Input location (e.g., using geocoding to get coordinates)
def get_coordinates(input_location):
    geolocator = Nominatim(user_agent="nearest_hospitals")
    location = geolocator.geocode(input_location)
    if location:
        return location.latitude * 3.14159265358979323846 / 180.0, location.longitude * 3.14159265358979323846 / 180.0
    else:
        return None

@app.route('/')
def index():
        input_location = 'Kanuru'
        input_coordinates = get_coordinates(input_location)

        if input_coordinates:
            # Define the maximum distance for the nearest neighbor search (in meters)
            max_distance = 1000

            # Find hospitals within the specified distance
            indices = ball_tree.query_radius([input_coordinates], r=max_distance)

            if len(indices[0]) > 0:
                # Find the top 10 closest hospitals
                num_closest_hospitals = 5

                # Sort hospitals by distance and get the top indices
                distances = [geopy.distance.distance((input_coordinates[0] * 180.0 / 3.14159265358979323846, input_coordinates[1] * 180.0 / 3.14159265358979323846),
                                                    (hospital_data['latitude'][index] * 180.0 / 3.14159265358979323846, hospital_data['longitude'][index] * 180.0 / 3.14159265358979323846)).m for index in indices[0]]
                sorted_indices = indices[0][sorted(range(len(distances)), key=lambda i: distances[i])]

                closest_hospitals = []
                for i, index in enumerate(sorted_indices[:num_closest_hospitals]):
                    hospital_name = hospital_data.at[index, 'places']
                    closest_hospitals.append(f"{i+1}. {hospital_name}")

                # Join the list of hospitals into a single string
                result_string = "\n".join(closest_hospitals)

                # Return the result string directly to the web page
                return result_string

            else:
                return "No hospitals found within the specified distance."
        else:
            return "Invalid input location or coordinates not found."

if __name__ == '__main__':
    app.run(host="192.168.82.42", port=3000, debug=True)

