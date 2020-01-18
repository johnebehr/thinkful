# Tuning KNN

While KNN is a relatively simple model, there are several things you can do to tune it performance.  These primarily have to do with how you handle distance and how many neighbors you include.

### Distance and Normalizing

As mentioned in 20.02, about distance measure you use for deciding how close other observations are to a test point, some of the nuance was glossed over.  Specifically, the measurement used assumes that all units are equal.  So, in the previous example, being 1 loudness unit away is equivalent to being 1 second away.  This is intensely problematic and one of the main issues people have with KNN.  Units are rarely equivalent and discerning how to adjust that inequivalence is an abstract and touchy subject.  This difficulty also makes binary or categorical variables nearly impossible to include in a KNN model.  It really is best if they are continuous.

It can be a more obvious challenge if you are dealing with something where the relative scales are strikingly different.  For example, if you are looking at buildings and you have height in floors and square footage, you'd have a model that would really only care about square footage since distance in that dimension would be far greater number of units than the number of floors.  

To deal with this, data scientists will engage in something called **normalization** Normalization is a way of taking these seemingly incommensurate measures and making them comparable.  There are two main normalization techniques that are effective with KNN.
1. You can set the bounds of the data to 0 and 1 and then **rescale** every variable to be within those bounds (it may also be reasonable to do -1 to 1, but the difference is immaterial).  This way every datapoint is measured in terms of its distance between the max and min of its category.  This is best if the data shows a linear relationship, such that scaling to a 0 to 1 range makes logical sense.  It is also best if there are known limits to the dataset, as those make for logical bounds for 0 and 1 for the rescaling.
2. You can also calculate how fare each observation is from the mean, expressed in number of standard deviations: this is often called _z-scores_.  calculating _z-scores_ and using them as the basis for measuring distance works for continuous data and puts everything in terms of how far from the mean (or "abnormal") it is.

Either of these techniques are viable for most situations and you'll have to use your intuition to see which make the most sense.  Mixing them, while possible, is usually a dangerous proposition.

### Weighting

There is one more thing to address when talking about distance, and that is weighting.  In the vanilla version of KNN, all **_k_** of the closest observations are given equal votes on what the outcome of the test observation should be.  When the data is densely populated that isn't necessarily a problem.  Particularly if there is variance in the measurement itself, not trying to draw information from small differences in distance can be wise.   

However, sometimes the **_k_** nearest observation are not all similarly close to the test.  In that case it may be useful to weight by distance.  Functionally this will weight by the inverse of distance, do that the closer datapoints (with a low distance) have a higher weight than further ones.  

`SKLearn` again makes this quite easy to implement.  There is an optional weights parameter that can be used when defining the model.  Set that parameter to "distance" and you will use distance weighting.  You'll try it below and also use the `stats` module from `SciPy` to convert the data to z-scores.



```python
import scipy

import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt

from sklearn.neighbors import KNeighborsClassifier
from scipy import stats # Not used in last module 20.02

music = pd.DataFrame()
music['loudness'] = [18, 34, 43, 36, 22, 9, 29, 22, 10, 24, 
                     20, 10, 17, 51, 7, 13, 19, 12, 21, 22,
                     16, 18, 4, 23, 34, 19, 14, 11, 37, 42]
                     
music['duration'] = [184, 134, 243, 186, 122, 197, 294, 382, 102, 264, 
                     205, 110, 307, 110, 397, 153, 190, 192, 210, 403,
                     164, 198, 204, 253, 234, 190, 182, 401, 376, 102]

music['jazz'] = [ 1, 0, 0, 0, 1, 1, 0, 1, 1, 0,
                  0, 1, 1, 0, 1, 1, 0, 1, 1, 1,
                  1, 1, 1, 1, 0, 0, 1, 1, 0, 0]
```


```python
neighbors = KNeighborsClassifier(n_neighbors=5, weights="distance")

# Input dataframe will be z-scores this time instead of raw data
X = pd.DataFrame({
    "loudness": stats.zscore(music["loudness"]),
    "duration": stats.zscore(music["duration"])
})

# Fit the model
Y = music.jazz
neighbors.fit(X,Y)

# Arrays, not dataframes, for the mesh
X = np.array(X)
Y = np.array(Y)

# Mesh size
h = 0.01

# Plot the decision boundry.  Assign a color to each point in the mesh
x_min = X[:, 0].min() - 0.5
x_max = X[:, 0].max() + 0.5 
y_min = X[:, 1].min() - 0.5
y_max = X[:, 1].max() + 0.5

xx, yy = np.meshgrid(
    np.arange(x_min, x_max, h), 
    np.arange(y_min, y_max, h)
)

Z = neighbors.predict(np.c_[xx.ravel(), yy.ravel()])

# Put the result into a color plot
Z = Z.reshape(xx.shape)
plt.figure(1, figsize=(6, 4))
plt.set_cmap(plt.cm.Paired)
plt.pcolormesh(xx, yy, Z)

# Add the training points to the plot.
plt.scatter(X[:, 0], X[:, 1], c=Y)
plt.xlabel('Loudness')
plt.ylabel('Duration')

plt.xlim(xx.min(), xx.max())
plt.ylim(yy.min(), yy.max())

plt.show();

```


![svg](output_2_0.svg)


This is a much more nuanced decision boundary, but it's also relatively continuous and consistent, providing a nice sense of which regions are likely to be which classification.

### Choosing K 

The last major aspect of tuning KNN is picking **_k_**.  This choice is largely up to the data scientist building the model but there are some things to consider.

Choosing **_k_** is a tradeoff.  The larger the **_k_** the more smoothed out the decision space will be, with more observation getting a vote in the prediction.  A smaller **_k_** will pick up more subtle deviations, but these deviations could be just randomness and therefore you could just be overfitting.  Add in weighting and that's an additional dimension to this conversation.

In the end, the best technique is probably to try multiple models and use your validation techniques to see which is best.  In particular, _k-fold_ cross validation is a great way to see how you KNN model is performing.

## DRILL:

Let's say we work at a credit card company and we're trying to figure out if people are going to pay their bills on time. We have everyone's purchases, split into four main categories: groceries, dining out, utilities, and entertainment. What are some ways you might use KNN to create this model? What aspects of KNN would be useful? Write up your thoughts in submit a link below.

### RESPONSE:

Building a predictive model for credit card repayment using these four variables: _Groceries_, _Dining Out_, _Utilities_, and _Entertainment_ using KNN could be achievable.  Knowledge about how consumers pay for these categories can help inform the K-Nearest Neighbor model.  Consumers who pay for Groceries and Utilities with cash tend to be more responsible, money-wise.   [The Payments Review](http://www.thepaymentsreview.com/why-shoppers-use-debit-cards-at-the-market) points out that there is "a general consensus that using a debit card helps a cardholder manage personal budgets for 'everyday expenses' such as groceries and gas".  [MarketWatch](https://www.marketwatch.com/story/this-is-why-americans-are-broke-and-fat-2017-12-05-10881649) goes into further detail on the spending side while buttressing the arguments made in the previous article.  Dining Out and Entertainment sit opposed to the other variables.  [(M)oneyunder30](https://www.moneyunder30.com/the-true-cost-of-eating-in-restaurants-and-how-to-save) goes into detail about the hidden costs of eating out and that might suggest that customer with large outlays for Dining Out are aware of what they are doing.  The Entertainment variable pairs with Dining Out for the same reasons.  

Having these insights into the variables can help inform the decisions applied to the KNN model.   The first thing to do is to determine **_k_**, an arbitrary number can be used but there might be a more quantitative method using the [Elbow Method](https://www.scikit-yb.org/en/latest/api/cluster/elbow.html) which attempts to select the optimal number of clusters by fitting a model with a range of values.

Once **_k_** has been decided you'll want to weight the variables such that neighbors with lower _Groceries_ and _Utilities_ values win out over the _Dining Out_ and _Entertainment_ variables.  You could go further and adjust the weights in an ordinal fashion to further refine the weighting for the model.

