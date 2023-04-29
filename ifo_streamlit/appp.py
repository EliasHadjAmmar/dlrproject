


    ########## GUI Imports
import streamlit as st
from streamlit_folium import st_folium
import folium
from PIL import Image

# from ressources import HelperFunctions
# HelperFunctions.add_dlr_logo_to_page()

########## Data Processing ##########
from shapely.geometry import shape
import geopandas as gpd

#Tif image
fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
image = Image.open(fn)
st.image(image)

# Map Title
st.title("Map")

########## Folium Map Styling ##########

def style_function(feature):
    return {
        'fillColor': 'blue',
        'color': 'black',
        'weight': 1,
        'fillOpacity': 0.1,
        'opacity': 0.5,
    }

def output():
    ########## Output ##########
    print("last neighborhoods FID:")
    print(last_neighborhoods_fid)
    print("last neighborhoods center coords:")
    print(last_neighborhoods_coords)
    print("last click coords:")
    print(last_click_coords)
########## Variables ##########
# first latitude then longitude 
last_neighborhoods_coords = [0, 0]
last_neighborhoods_fid = 0
last_click_coords = [0, 0]

########## Load GeoPackage source file ########## 
#Enable for only using testing data 
neighborhoods_berlin= gpd.read_file("/Users/nathan/Desktop/ifo_streamlit/Example_Bremen_Land_Values_Neighborhood.gpkg")
#neighborhoods_berlin= gpd.read_file("./ifoHack_DLR_Challenge_Data/1 Land Prices/Land_Prices_Neighborhood_Berlin.gpkg")


m = neighborhoods_berlin.explore(height=500, width=1000, name="Neighborhoods")

#custom figure
#folium.GeoJson(neighborhoods_berlin, style_function=style_function, highlight_function=lambda x: {'weight':3,'fillOpacity':0.3, 'fillColor': 'red',}).add_to(m)


folium.LayerControl().add_to(m)

# call to render Folium map in Streamlit
st_data = st_folium(m, width=725)

if st_data['last_active_drawing'] is not None:
    keysList = list(st_data.keys())
    #print(keysList)
    #print(st_data['last_active_drawing']['id'])
    #print(type(st_data['last_active_drawing']['geometry']['coordinates']))
    
    ########## Get FID and Coords ##########
    last_neighborhoods_fid = st_data['last_active_drawing']['properties']['Neighborhood_FID']
    last_click_coords = [st_data['last_clicked']['lat'], st_data['last_clicked']['lng']]

    ########## Get centroid from Area ##########
    polygon_coords = st_data['last_active_drawing']['geometry']
    coord = shape(polygon_coords).centroid
    last_neighborhoods_coords = [coord.y, coord.x] #longitude / latitude

    output()
