app = blink.App();

app.get("/", @home);
app.StaticFiles = "/Users/david/blink/examples/static";
port = 8000;
fprintf("Listening on port: %d\n", port);
app.serve(Port=port)

function resp = home(~, resp)
resp = resp.render("templates/home.mtl");
end
