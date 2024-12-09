from googleapiclient.discovery import build

from app.config import Config

youtube = build('youtube', 'v3', developerKey=Config.YOUTUBE_API_KEY)

class YtVideoInfos:
    channel_video_count = {}

# https://www.youtube.com/@Max0r
def check_for_new_yt_video_action(channel_id: str = 'UCfgh3Ul_dG6plQ7rzuOLx-w') -> bool:
    video_infos = YtVideoInfos()

    # pylint: disable=E1101
    request = youtube.channels().list(
        part='statistics',
        id=channel_id
    )

    response = request.execute()
    new_video_count = response['items'][0]['statistics']['videoCount']

    if channel_id not in video_infos.channel_video_count or new_video_count == video_infos.channel_video_count[channel_id]:
        video_infos.channel_video_count[channel_id] = new_video_count
        return False

    video_infos.channel_video_count[channel_id] = new_video_count
    return True
