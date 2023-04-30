import streamlit as st
from streamlit_folium import st_folium
import folium
from PIL import Image


########## Data Processing ##########
from shapely.geometry import shape
import geopandas as gpd

logo_image = "/Users/nathan/Desktop/ifo_streamlit/DLR_Logo.svg.png"
st.image(logo_image, use_column_width=True)


# Map Title
st.title("Map")

# Sidebar
data_options = {
    "Bremen": "/Users/nathan/Desktop/ifo_streamlit/Bremen_map.gpkg",
    "Berlin": "/Users/nathan/Desktop/ifo_streamlit/Berlin_map.gpkg",
    "Dresden": "/Users/nathan/Desktop/ifo_streamlit/Dresden_map.gpkg",
    "Frankfurt": "/Users/nathan/Desktop/ifo_streamlit/Frankfurt_am_Main_map.gpkg",
    "Köln": "/Users/nathan/Desktop/ifo_streamlit/Köln_map.gpkg"

}
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

    folium.LayerControl().add_to(m)

# call to render Folium map in Streamlit
    st_data = st_folium(m, width=725)
    print(data)

    st.write(data['Land_Value_predicted'])

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

if st.button("Click Me"):
        st.write("Image clicked!")

# if 'geometry' in data.columns:
#         m.canvas.mpl_connect('button_press_event', lambda event: onClick(event, data))

# def onClick(event, data):
#     if event.inaxes:
#         x = event.xdata
#         y = event.ydata
#         point = gpd.GeoSeries([gpd.points_from_xy([x], [y])], crs=data.crs)
#         selected_rows = data[data.intersects(point.unary_union)]
#         if not selected_rows.empty:
#             st.subheader("Selected Rows")
#             st.write(selected_rows)

# print(st_data)            


# #Tif image
# if data_path = "/Users/nathan/Desktop/ifo_streamlit/Land_Prices_Neighborhood_Bremen.gpkg":
#     fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
#     image = Image.open(fn)
#     st.image(image)
# elif data_path = "/Users/nathan/Desktop/ifo_streamlit/Land_Prices_Neighborhood_Bremen.gpkg":
#     fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
#     image = Image.open(fn)
#     st.image(image)
# elif data_path = "/Users/nathan/Desktop/ifo_streamlit/Land_Prices_Neighborhood_Bremen.gpkg":
#     fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
#     image = Image.open(fn)
#     st.image(image)
# elif data_path = "/Users/nathan/Desktop/ifo_streamlit/Land_Prices_Neighborhood_Bremen.gpkg":
#     fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
#     image = Image.open(fn)
#     st.image(image)
# else :
#     fn = "/Users/nathan/Desktop/ifo_streamlit/WorldCover_Bremen.tif"
#     image = Image.open(fn)
#     st.image(image)


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
