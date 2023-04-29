import streamlit as st
import geopandas as gpd
import folium
import rioxarray as riox
import numpy as np
import matplotlib.pyplot as plt
import os
from streamlit_folium import folium_static



# Read in GeoPackage files
neighborhoods_bremen = gpd.read_file("/Users/nathan/Desktop/ifo_streamlit/Example_Bremen_Land_Values_Neighborhood.gpkg")
buildings_bremen = gpd.read_file("/Users/nathan/Desktop/ifo_streamlit/Example_Bremen_Buildings.gpkg")

# Create Folium map object
m = folium.Map(location=[neighborhoods_bremen.geometry.centroid.y.mean(), 
                         neighborhoods_bremen.geometry.centroid.x.mean()], 
               zoom_start=12)

# Add neighborhoods layer to map
folium.GeoJson(neighborhoods_bremen).add_to(m)

# Add buildings layer to map
folium.GeoJson(buildings_bremen, style_function=lambda x: {'color': 'red'}).add_to(m)

# Add layer control to map
folium.LayerControl().add_to(m)

# Display map in Streamlit
st.title("Bremen Land Values Map")
folium_static(m)


# westend = neighborhoods_bremen.loc[neighborhoods_bremen.Neighborhood_Name == "Westend"]
# buildings_westend = buildings_bremen.clip(westend.geometry)

# m = westend.explore(height=500, width=1000, name="Neighborhoods")
# m = buildings_westend.explore(m=m, color="red", name="Buildings")

# folium.LayerControl().add_to(m)
# m

# westend_area = westend.area.values[0]
# buildings_area = np.sum(buildings_westend.area)
# print(westend_area)
# print(buildings_area)

# building_density = buildings_area / westend_area * 100
# print(building_density)

# building_density = []  # Empty List which gets filled iteratively
# neighborhood_names = neighborhoods_bremen.Neighborhood_Name.values  # Needed for loop and indexing

# for neighborhood in neighborhood_names:
#     subset = neighborhoods_bremen.loc[neighborhoods_bremen.Neighborhood_Name == neighborhood]  # Get one neighborhood
#     buildings_clip = buildings_bremen.clip(subset.geometry)  # Clip all buildings to one neighborhood
#     building_density.append(np.sum(buildings_clip.area) / subset.area.values[0] * 100)  #  Building Area / Total Area = Density
    
# neighborhoods_bremen["Building_Density"] = building_density  # Add new list to dataframe

# neighborhoods_bremen.head()

# m = buildings_bremen.explore(color="gray", name="Buildings")
# m = neighborhoods_bremen.explore(m=m, height=500, width=1000, name="Neighborhoods",
#                              column = "Building_Density", scheme = "quantiles", cmap = "RdYlBu_r", legend = True)


# folium.LayerControl().add_to(m)
# m