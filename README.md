# Application description

## API description

 - Request to `https://analyricexperimentsapp.onrender.com/api/analytic_experiments` has to have  HTTP header `Device-Token`. In other case api for this request will return `{"error":"'Device-Token' header value is empty!"}` message and Bad Request status (400).   
   Request with header will return all available for sent token A/B experiment variants. All tokens will take part in testing only in younger tests than token. If a token was saved by system 3 day ago, it won't be taken part in test created today, but will take part in test created 4 days ago.

## Admin part description

 - Go to the `https://analyricexperimentsapp.onrender.com/admin/analytic_experiments` or to the just `https://analyricexperimentsapp.onrender.com/` for checking the list of all analytic experiments. Each experiment in this list has the link  to the detail page. On this page you can see all options of experiment: name of experiment, available variants, device count in each variant, device count in hole experiment, limits for each variant and current filling percentage. 

---

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
