import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor

def model_fit(X_train, y_train):

    X_train = X_train.drop("City_Name", axis=1)

    # Set hyperparameters
    n_estimators = 1000
    max_depth = 100
    k_features = 50

    # I had feature selection as well but I can't bring it into this functional form in the next minutes

    # Train a random forest
    model = RandomForestRegressor(n_estimators=n_estimators, max_depth=max_depth, random_state=42)
    model.fit(X_train, y_train)

    return model


def model_predict(model, X_test):

    X_test = X_test.drop("City_Name", axis=1)
    
    y_pred = model.predict(X_test)

    return y_pred
