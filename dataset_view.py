import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def boxPlot(data,x_feat,target_feat):
    # instanciate the figure
    plt.figure(figsize = (8, 6), dpi = 80)
    # plot the data using seaborn
    ax = sns.boxplot(x = x_feat, y = target_feat, data = data)


    # ----------------------------------------------------------------------------------------------------
    # prettify the plot

    # change the font of the x and y ticks (numbers on the axis)
    ax.tick_params(axis = 'x', labelrotation = 90, labelsize = 12)
    ax.tick_params(axis = 'y', labelsize = 12)

    # set and x and y label
    ax.set_xlabel(x_feat, fontsize = 14)
    ax.set_ylabel(target_feat, fontsize = 14)

    # set a title
    ax.set_title(str(x_feat)+" VS "+str(target_feat), fontsize = 14)
