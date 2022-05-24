# Import data
import time
from traceback import print_exc
import numpy as np
#Log: 9-feb-2022 @arocha : File creation
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

#["plotly", "plotly_white", "plotly_dark", "ggplot2", "seaborn", "simple_white", "none"]
theme= "plotly_white"




sensivilityCubinder = np.genfromtxt("../Outputs/Dataframes/slides_visibility.csv", delimiter=',')
print(sensivilityCubinder.shape)
# Plot scatter 3d - (PHASE & FREQ)                         

for i in range(0,20):
    fig = px.imshow(sensivilityCubinder[i,:,:])
    fig.show()