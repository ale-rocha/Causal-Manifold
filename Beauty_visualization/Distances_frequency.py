
# Instituto Nacional de Astrofisica Optica y Electronica Mx.
# Dep. de Ciencias de la computacion
# Alejandra Rocha Solache

#Log: 16-feb-2022 @arocha : File creation

import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pandas as pd
import numpy as np


def diff_of_distances (distances):
    is_c = False
    c_aux = 0
    all_vars = []
    vars = -1
    for d in range(1,len(distances)-1):
        c = round(abs(distances[d-1] - distances[d]),2)
        if c!=c_aux:
            vars += 1
            c_aux = c
            all_vars.append(c)
    return [all_vars,vars,c_aux]


# Initialize figure with subplots
fig = make_subplots(
    rows=2, cols=2,
    column_widths=[0.6, 0.4],
    row_heights=[0.4, 0.4],
    subplot_titles=("Cubinder - (Phase, freq view)",
                    'Distance function',
                    "CDMScale (Phase)- 2 dimensions"),
    specs=[[{"type": "scatter3d", "rowspan": 2}, {"type": "scatter"}],
          [            None                    , {"type": "scatter"}]])


# read cubinder --------------------------------------------------------------------------------
events_cubinder = np.genfromtxt("../Outputs/Dataframes/dataframe_events_cubinder.csv", delimiter=',')
events_cubinder = pd.DataFrame(data={'event_id':events_cubinder[:,0],
                              'sen_phase':events_cubinder[:,1],
                              'cos_phase':events_cubinder[:,2],
                              'event_phase':events_cubinder[:,3],
                              'event_frequency':events_cubinder[:,4],
                              'event_ftime':events_cubinder[:,5]})

fig.add_trace(
    go.Scatter3d(x=events_cubinder["sen_phase"],y=events_cubinder["cos_phase"],z=events_cubinder["event_frequency"]),
    row=1, col=1
)

# read CDM SCALE --------------------------------------------------------------------------------
cdmscale_diff_phase = np.genfromtxt("../Outputs/Dataframes/dataframe_test_distances_frequency_cdmscale.csv", delimiter=',')
cdmscale_diff_phase = pd.DataFrame(data={'X':cdmscale_diff_phase[:,0],
                                         'Y':cdmscale_diff_phase[:,1]})
fig.add_trace(
    go.Scatter(x=cdmscale_diff_phase["X"],y=cdmscale_diff_phase["Y"],
    mode="markers",
    hoverinfo="text",
    showlegend=False,
    marker=dict(color="crimson", size=4, opacity=0.8) ),
    row=2, col=2
)
fig['layout']['xaxis2']['title']='Distances sin(phase)'
fig['layout']['yaxis2']['title']='Distances cos(phase)'

# Read distance function ---------------------------------------------------------------------
cdmscale_diff_fun = np.genfromtxt("../Outputs/Dataframes/dataframe_test_distances_function_freq.csv", delimiter=',')
cdmscale_diff_fun = pd.DataFrame(data={'X':cdmscale_diff_fun[:]})
all_vars,vars , c_diff = diff_of_distances (cdmscale_diff_fun["X"])
if vars == 0:
    print("Todas las diferencias de distancias son iguales c: ",c_diff)
else:
    print("Hay problemas",all_vars)

events_number = np.arange(0,cdmscale_diff_fun["X"].shape[0],1)
fig.add_trace(
    go.Scatter(x=events_number,y=cdmscale_diff_fun["X"],
    mode="markers",
    showlegend=False),
    row=1, col=2
)

fig['layout']['xaxis']['title']='Number of event'
fig['layout']['yaxis']['title']='Distance c= '+str(c_diff)


# Set theme, margin, and annotation in layout ----------------------------------------------------
fig.update_layout(
    template="gridon", #plotly_dark
)

fig.show()