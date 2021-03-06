% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_model_drift.R
\name{calculate_model_drift}
\alias{calculate_model_drift}
\title{Calculate Model Drift for comparison of models trained on new/old data}
\usage{
calculate_model_drift(model_old, model_new, data_new, y_new,
  predict_function = predict, max_obs = -1, scale = sd(y_new, na.rm =
  TRUE))
}
\arguments{
\item{model_old}{model created on historical / `old`data}

\item{model_new}{model created on current / `new`data}

\item{data_new}{data frame with current / `new` data}

\item{y_new}{true values of target variable for current / `new` data}

\item{predict_function}{function that takes two arguments: model and new data and returns numeric vector with predictions, by default it's `predict`}

\item{max_obs}{if negative, them all observations are used for calculation of PDP, is positive, then only `max_obs` are used for calculation of PDP}

\item{scale}{scale parameter for calculation of scaled drift}
}
\value{
an object of a class `model_drift` (data.frame) with distances calculated based on Partial Dependency Plots
}
\description{
This function calculates differences between PDP curves calculated for new/old models
}
\examples{
 library("DALEX2")
 \dontrun{
 library("ranger")
 predict_function <- function(m,x,...) predict(m, x, ...)$predictions
 model_old <- ranger(m2.price ~ ., data = apartments)
 model_new <- ranger(m2.price ~ ., data = apartments_test)
 calculate_model_drift(model_old, model_new,
                  apartments_test,
                  apartments_test$m2.price,
                  max_obs = 1000,
                  predict_function = predict_function)

 # here we compare model created on male data
 # with model applied to female data
 # there is interaction with age, and it is detected here
 predict_function <- function(m,x,...) predict(m, x, ..., probability=TRUE)$predictions[,1]
 data_old = HR[HR$gender == "male", -1]
 data_new = HR[HR$gender == "female", -1]
 model_old <- ranger(status ~ ., data = data_old, probability=TRUE)
 model_new <- ranger(status ~ ., data = data_new, probability=TRUE)
 calculate_model_drift(model_old, model_new,
                  HR_test,
                  HR_test$status == "fired",
                  max_obs = 1000,
                  predict_function = predict_function)

 # plot it
 library("ceterisParibus2")
 prof_old <- individual_variable_profile(model_old,
                                     data = data_new,
                                     new_observation = data_new[1:1000,],
                                     label = "model_old",
                                     predict_function = predict_function)
 prof_new <- individual_variable_profile(model_new,
                                     data = data_new,
                                     new_observation = data_new[1:1000,],
                                     label = "model_new",
                                     predict_function = predict_function)
 plot(prof_old, prof_new,
      selected_variables = "age", aggregate_profiles = mean,
      show_observations = FALSE, color = "_label_")
}

}
