import sentry_sdk

# Configure the Sentry SDK with your DSN
sentry_sdk.init("https://53ad9fcbd7b148f3b112b070381ea9fe@o4504684634001824.ingest.sentry.io/4504384657508652")

# Define a function that will throw an error
def function_that_fails():
    raise ValueError("Something went wrong")

# Call the function and capture any errors with Sentry
try:
    function_that_fails()
except Exception as e:
    sentry_sdk.capture_exception(e)

# Print a success message
print("The Sentry SDK is working!")
