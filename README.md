# flutter_max_player
[![pub package](https://img.shields.io/pub/v/flutter_max_player.svg)](https://pub.dartlang.org/packages/flutter_max_player)

Max Player - To Make Video Player Widget

## preview
<img src="https://raw.githubusercontent.com/RutvikRana/flutter_max_player/main/video_example/example.gif" alt="" width="400" height="250">

## What It Can Do?
* Play Videos From Asset / Network / File
* Zoom On Video
* Lock/Unlock Player
* Prev,Next,Cropping Options
* TitleBar Options
* ColorTheme Options

## Installation
```	dependencies:
	  flutter_max_player: ^0.0.1
	  video_player: ^0.11.0
	  screen: ^0.0.5
	  zoomer: ^0.0.4	  
```

video_player: Dependency made by Flutter Team.
screen: to control brightness
zoomer: to zoom on video ( created by me :) )

## Syntax

1. VideoView Class
```
		VideoView(
			this.source,                            //Source Of Video URL / AssetPath / FilePath
			{this.sourceType = SourceType.Asset,    //Type Of Source default is Asset
			this.height,                            //Height (Optional)
			this.width,				//Widget (Optional)
			this.autoPlay = false,			//AutoPlay on start ?
			this.muteOnPlay = false,		//Mute On Start ?
			this.getController,			//Get VideoPlayerController of video_player
			this.hideShowDuration = 		//Hide/Show Animation Duration
				const Duration(milliseconds: 500),
			this.maxZoomScale=2.0,			// Maximum Zoom
			this.minZoomScale=0.5,			// Minimum Zoom
			this.onBackClick,			// On Back Button Click
			this.onNextClick,			// On Next Button Click
			this.scrubDragConstant=0.2,		// Scrub ( Horizontal ) Drag Constant
			this.volumeDragConstant=0.01,		// Volume Drag Constant
			this.videoPlayerOptions,		// Same of video_player
			this.leading,				// Leading of titlebar
			this.title,				// Title of titlebar
			this.tailing,				// Trailing of titlebar
			this.rebuildOnupdate = false,		// If true Re-Initialisation on didUpdateWidget
			this.videotheme				// ColorTheme
		});
```
2. VideoViewTheme Class To Change Colors 
```
		VideoViewTheme({
			this.iconColor,
			this.textColor,
			this.backgroundColor,
			this.foregroundColor,
			this.volumeBarEmptyColor,
			this.volumeBarFillColor,
			this.brightnessBarEmptyColor,
			this.brightnessBarFillColor,
			this.timeBarEmptyColor,
			this.timeBarFillColor
		})
```

## Example

```
VideoView("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
	sourceType: SourceType.Network,
	title: Text("Big Buck Bunny",style: TextStyle(fontSize: 20),
))
```

## Contact Me

I Am Rutvik Rana, Medical Student cum Passionate Coder, Invite You To My [Coding(noob to pro)](https://t.me/coding_noob_to_pro) Channel.
