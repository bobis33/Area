import uvicorn

if __name__ == "__main__":
    uvicorn.run("app.__init__:app", host="0.0.0.0", port=8080, reload=True, log_level='debug')
