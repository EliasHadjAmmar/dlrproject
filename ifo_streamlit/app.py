import streamlit as st
from streamlit_folium import st_folium
import folium
from PIL import Image, ImageFilter

from shapely.geometry import shape
import geopandas as gpd




# Map Title
st.title("Interactive Land Prices Map")

text = """Note that you can choose the layer you want by changing the selection in the top right
corner of map. Neighborhoods provides descriptive information on neighborhood being hovered on.
macro_element_div_3 displays segregation levels by color, but not specific neighborhood data"""

st.markdown(text)


# Sidebar
data_options = {
    "Bremen": "/Users/nathan/Library/CloudStorage/GoogleDrive-nathanmbewe5@gmail.com/.shortcut-targets-by-id/1j495iyGjPzVzr6s5r1wsfRbHdWi1nifC/ifoHack2023/output/Bremen_map.gpkg",
    "Berlin": "/Users/nathan/Library/CloudStorage/GoogleDrive-nathanmbewe5@gmail.com/.shortcut-targets-by-id/1j495iyGjPzVzr6s5r1wsfRbHdWi1nifC/ifoHack2023/output/Berlin_map.gpkg",
    "Dresden": "/Users/nathan/Library/CloudStorage/GoogleDrive-nathanmbewe5@gmail.com/.shortcut-targets-by-id/1j495iyGjPzVzr6s5r1wsfRbHdWi1nifC/ifoHack2023/output/Dresden_map.gpkg",
    "Frankfurt": "//Users/nathan/Library/CloudStorage/GoogleDrive-nathanmbewe5@gmail.com/.shortcut-targets-by-id/1j495iyGjPzVzr6s5r1wsfRbHdWi1nifC/ifoHack2023/output/Frankfurt_am_Main_map.gpkg",
    "Köln": "/Users/nathan/Library/CloudStorage/GoogleDrive-nathanmbewe5@gmail.com/.shortcut-targets-by-id/1j495iyGjPzVzr6s5r1wsfRbHdWi1nifC/ifoHack2023/output/Köln_map.gpkg"

}
# logo image

logo_image = "/Users/nathan/Desktop/ifo_streamlit/DLR_Logo.svg.png"


st.sidebar.image(logo_image, width = 200)
selected_option = st.sidebar.selectbox("Select Data Option and hover over area", list(data_options.keys()))

def load_data(path):
    return gpd.read_file(path)

try:        
    data_path = data_options[selected_option]        
    data = load_data(data_path)        
    m = data.explore(height=500, width=1000, name="Neighborhoods", tiles=None)

#custom figure
#folium.GeoJson(neighborhoods_berlin, style_function=style_function, highlight_function=lambda x: {'weight':3,'fillOpacity':0.3, 'fillColor': 'red',}).add_to(m)

    folium.TileLayer('stamentoner').add_to(m)

    folium.Choropleth(
        geo_data=data,  # Replace with the path to your GeoJSON file
        data=data,
        columns=['Neighborhood_FID', 'segregation_H'],  # Replace with the column names in your data
        key_on='feature.properties.Neighborhood_FID',
        fill_color='YlGnBu',  # Specify the color scale or use a custom color scheme
        fill_opacity=0.7,
        line_opacity=0.2,
        legend_name='Segregation Level',
        highlight=True
        ).add_to(m)

    
    folium.LayerControl().add_to(m)


# call to render Folium map in Streamlit
    st_data = st_folium(m, width=725)
    text2 = """The tables present Actual Land Values (Left),  Predicted Land Values (Middle) 
    and Segregation values (Right) Neighborhood number
"""

    st.markdown(text2)


    data1= data['Land_Value']
    data2= data['Land_Value_predicted']
    data3= data["segregation_H"]


# Create two columns for layout
    col1, col2, col3 = st.columns(3)

# Display the first table
    with col1:
        st.dataframe(data1)

# Display the second table
    with col2:
        st.dataframe(data2)

# Display the second table
    with col3:
        st.dataframe(data3)

    




    if st_data['last_active_drawing'] is not None:
        keysList = list(st_data.keys())
    #print(keysList)
    #print(st_data['last_active_drawing']['id'])
    #print(type(st_data['last_active_drawing']['geometry']['coordinates']))
    
    ########## Get FID and Coords ##########
        st_data
        last_neighborhoods_fid = st_data['last_active_drawing']['properties']['Neighborhood_FID']
        last_click_coords = [st_data['last_clicked']['lat'], st_data['last_clicked']['lng']]

    ########## Get centroid from Area ##########
        polygon_coords = st_data['last_active_drawing']['geometry']
        coord = shape(polygon_coords).centroid
        last_neighborhoods_coords = [coord.y, coord.x] #longitude / latitude

        output()    
        
except Exception as e:        
    st.sidebar.error(f"Error loading data: {str(e)}")





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
