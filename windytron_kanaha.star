load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

url = "http://wildc.net/wind/kanaha.json"

def fetch_data():
    rep = http.get(url)
    if rep.status_code != 200:
        fail("request failed with status %d", rep.status_code)
    data = rep.json()["spots"][0]["stations"][0]["data_values"][0][2:7]
    return data

def main():

    data = fetch_data()
    wind_avg = int(data[0]*0.87+0.5)

    wind_lull = 0 #int(data[1]*0.87+0.5)
    wind_gust = int(data[2]*0.87+0.5)
    wind_dir = data[4].strip('"')
    wind_dir_degrees = data[3]

    swell1 = "3.9f,13s,N352"
    color_light = "#00FFFF" #cyan
    color_medium = "#AAEEDD" #??
    color_strong = "#00FF00" #green
    color_beast = "#FF0000" # red
    wind_color = color_medium
    if (wind_avg < 10):
        wind_color = color_light
    elif (wind_avg < 25):
        wind_color = color_medium
    elif (wind_avg < 30):
        wind_color = color_strong
    elif (wind_avg >= 30):
        wind_color = color_beast

    return render.Root(
        child = render.Box(
            render.Column(
                cross_align="center",
                main_align = "center",
                children = [
                    render.Text(
                        content = "Windy-Tron",
                        font = "tb-8"
                    ),

                    render.Text(
                        content = "%dg%d kts" % (wind_avg, wind_gust),
                        font = "6x13",
                        color = wind_color
                    ),
#                     render.Text(
#                         content = "%s " % wind_dir,
#
#                     ),
                    render.Text(
                        content = "%s %d°" % (wind_dir,wind_dir_degrees),
                        color = "#FFAA00",


                    ),

                ],
            ),

        ),
    )
