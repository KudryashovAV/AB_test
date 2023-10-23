# Test task

We create mobile applications and sometimes we have to run AB-tests to test hypotheses. To do this, we need a system that is a simple REST API consisting of a single endpoint.

## API and Distribution
When the mobile application is launched, it generates some unique client ID (which is saved between sessions) and requests a list of experiments by adding the HTTP header `Device-Token`. In response, the server gives a list of experiments. For each experiment, the client receives:

- Key: the name of the experiment. There is a code in the client that will change some behavior depending on the value of this key
- Value: string, one of the possible options (see below)

It is important that the device falls into one group and always stays in it.

# Experiments
### 1. Button color
   We have a hypothesis that the color of the "buy" button affects the conversion to purchase

Key: `button_color`

Options:

- `#FF0000` → 33.3%
- `#00FF00` → 33.3%
- `#0000FF` → 33.3%

So after 600 API requests with different `DeviceToken`, each color should receive 200 devices

### 2. Purchase price
   We have a hypothesis that a change in the cost of an in-app purchase may affect our margin profit. But in order not to lose money in case of an unsuccessful experiment, 75% of users will receive the old price and only a small part of the audience will test the change.:

Key: `price`

Options:

- `10` → 75%
- `20` → 10%
- `50` → 5%
- `5` → 10%

## Requirements and restrictions

1. If the device has received a value once, then it will always receive only it
2. The experiment is conducted only for new devices: if the experiment was created after the first request from the device, then the device should not know anything about this experiment

## Task

1. Design, describe and implement the API
2. Add experiments (1) and (2) to the app
3. Create a page for statistics: a simple table with a list of experiments, the total number of devices participating in the experiment and their distribution among the options 

You can use any tenchologies and libraries

The plus will be:

- Availability of tests
- Backplayed version of the application
- Server response rate <100ms
