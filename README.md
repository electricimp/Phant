Phant IO
=========
The Phant class wraps the PhantIO / [data.sparkfun.com](https://data.sparkfun.com) API. It is a very simple data store to get up and running with.

### Callbacks
All methods in the Phant class take an optional callback parameter. The callback expects two parameters: error, and data. If the request was successful, err will be ```null```, and data will contain the response. If the request was unsucessful, err will contain the error information.

When the optional callback is passed, the requests will be made asynchronously. If a callback is not supplied, the request will be made synchronously, and a table containing err and data will be returned.

## constructor(publicKey, privateKey, [baseUrl])
The Phant constructor takes three parameters - the instances public key, private key, and an optional base url. If no url is specified, the class will use Sparkfun's [https://data.sparkfun.com](https://data.sparkfun.com) as the base:

```squirrel
// Agent Code
#require "phant.class.nut:1.0"

stream <- Phant("<-- PUBLIC_KEY -->", "<-- PRIVATE_KEY -->");
```

## stream.push(data, [callback])
The *push* method pushes a new event into your Phant instance. The first parameter - *data* - must be a Squirrel table containing the data to be pushed:

**Device Code:**
```squirrel
function poll() {
  imp.wakeup(15, poll)
  agent.send("temp", getTemp());
} poll();
```

**Agent Code:**
```squirrel
device.on("temp", function (tempData) {
  //Asyncronous Push:
  stream.push({ temp = tempData }, function(err, data) {
    if (err != null) {
      // if it failed, log the reason
      server.error(http.jsonencode(err));
      return;
    }
  });
});
```

## stream.get([callback])
The *get* method retreives the current contents of your Phant instance:

```squirrel
stream.get(function(err, data) {
  if (err != null) {
    server.error(http.jsonencode(err));
    return;
  }

  // calculate average temperature
  local avgTemp = 0.0;
  foreach(datapoint in data) {
    avgTemp += datapoint.temp;
  }
  avgTemp = avgTemp / data.len();

  // log average temperature
  server.log("Average Temperature: " + avgTemp);
});
```

## stream.clear([callback])
The *clear* method clears **ALL** information stored in the Phant instance:

```squirrel
stream.clear(function(err, data) {
  if (err != null) {
    server.error(http.jsonencode(err));
    return;
  }
});
```

# License
The Phant library and example code are licensed under the [MIT License](./LICENSE).
