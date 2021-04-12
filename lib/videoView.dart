//importing...
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'package:zoomer/zoomer.dart';

//SourceType
///SourceType = Asset / File / Network
enum SourceType{
  Asset,File,Network
}

///Create Color Theme For VideoView.
class VideoViewTheme{
  //iconColor
  Color iconColor;
  //textColor
  Color textColor;
  //backgroundColor
  Color backgroundColor;
  //foregroundColor
  Color foregroundColor;
  //volumeBarEmptyColor
  Color volumeBarEmptyColor;
  //volumeBarFillColor
  Color volumeBarFillColor;
  //brightnessBarEmptyColor
  Color brightnessBarEmptyColor;
  //brightnessBarFillColor
  Color brightnessBarFillColor;
  //timeBarEmptyColor
  Color timeBarEmptyColor;
  //timeBarFillColor
  Color timeBarFillColor;
  ///Create Color Theme For VideoView.
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
    this.timeBarFillColor}){
      this.iconColor = fillNull(this.iconColor, Colors.black);
      this.textColor = fillNull(this.textColor, Colors.white);
      this.backgroundColor = fillNull(this.backgroundColor, Colors.black);
      this.foregroundColor = fillNull(this.foregroundColor, Colors.blue.withAlpha(200));
      this.volumeBarEmptyColor = fillNull(this.volumeBarEmptyColor, Colors.blue.shade100);
      this.volumeBarFillColor = fillNull(this.volumeBarFillColor, Colors.blue);
      this.brightnessBarEmptyColor = fillNull(this.brightnessBarEmptyColor, Colors.orange.shade100);
      this.brightnessBarFillColor = fillNull(this.brightnessBarFillColor, Colors.orange);
      this.timeBarEmptyColor = fillNull(this.timeBarEmptyColor, Colors.white);
      this.timeBarFillColor = fillNull(this.timeBarFillColor, Colors.red);
    }
  //fillNull Function
  Color fillNull(Color c,Color fill){
    return c == null?fill:c;
  }
}

///Create Max Player VideoView Widget.
class VideoView extends StatefulWidget {
  //source
  final String source;
  //height,width,maxZoomScale,minZoomScale,volumeDragConstant,scrubDragConstant
  final double height,width,maxZoomScale,minZoomScale,volumeDragConstant,scrubDragConstant;
  //sourceType
  final SourceType sourceType;
  //videoPlayerOptions
  final VideoPlayerOptions videoPlayerOptions;
  //autoPlay,muteOnPlay,rebuildOnupdate
  final bool autoPlay,muteOnPlay,rebuildOnupdate;
  //hideShowDuration
  final Duration hideShowDuration;
  //getController
  final Function(VideoPlayerController) getController;
  //onBackClick,onNextClick
  final Function() onBackClick,onNextClick;
  //leading,title,tailing
  final Widget leading,title,tailing;
  //videotheme
  final VideoViewTheme videotheme;
  ///Create Max Player VideoView Widget.
  VideoView(this.source,{this.sourceType = SourceType.Asset,this.height,this.width,this.autoPlay = false,this.muteOnPlay = false,this.getController,this.hideShowDuration = const Duration(milliseconds: 500),this.maxZoomScale=2.0,this.minZoomScale=0.5,this.onBackClick,this.onNextClick,this.scrubDragConstant=0.2,this.volumeDragConstant=0.01,this.videoPlayerOptions,this.leading,this.title,this.tailing,this.rebuildOnupdate = false,this.videotheme});

  @override
  _VideoViewState createState() => _VideoViewState();
}

//_VideoViewState
class _VideoViewState extends State<VideoView> {
  //_controller
  VideoPlayerController _controller;
  //_initialiser
  Future<void> _initialiser;
  //_fullscreen
  bool _fullscreen = false;
  //_opacity
  bool _opacity = true;
  //_showRemainTime
  bool _showRemainTime = false;
  //_zoomerState
  ZoomerController _zoomerState = ZoomerController();
  //_resolution
  int _resolution = 0;  
  //_aspectRatio
  double _aspectRatio;
  //_scale100
  double _scale100;
  //_scaleHeight
  double _scaleHeight;
  //_startHdrag
  double _startHdrag = 0.0;
  //_startVdrag
  double _startVdrag = 0.0;
  //_volumeChange
  bool _volumeChange = true;
  //_startDuration
  Duration _startDuration;
  //_startVolume,_startBrightness
  double _startVolume,_startBrightness = 1.0;
  //_videoWidth
  double _videoWidth;  
  //_volumeOpacity,_brightnessOpacity
  bool _volumeOpacity = false,_brightnessOpacity = false;
  //_currentBrightness
  double _currentBrightness = 0;
  //_videoViewTheme
  VideoViewTheme _videoViewTheme;
  //_locked
  bool _locked = false;
  //_lockOpacity
  bool _lockOpacity = false;
  //_timer
  Timer _timer;

  //initState
  @override
  void initState(){
    initialise();
    super.initState();
  }
  //didUpdateWidget
  @override
  void didUpdateWidget(oldWidget){
    if(widget.rebuildOnupdate){initialise();}
    else{
      VideoPlayerController controller;
    switch (widget.sourceType) {
      case SourceType.Asset:
          controller = VideoPlayerController.asset(widget.source,videoPlayerOptions: widget.videoPlayerOptions);
        break;
      case SourceType.File:
          controller = VideoPlayerController.file(File(widget.source),videoPlayerOptions: widget.videoPlayerOptions);
        break;
      case SourceType.Network:
          controller = VideoPlayerController.network(widget.source,videoPlayerOptions: widget.videoPlayerOptions);
        break;
      default:
    }

    if(controller.dataSource != _controller.dataSource){      
      double volume = _controller.value.volume;
      initialise();
      _controller.setVolume(volume);
    }
    }
    super.didUpdateWidget(oldWidget);
  }
  //initialise
  void initialise(){
    if(_controller != null){
      _controller.dispose();
    }

    switch (widget.sourceType) {
      case SourceType.Asset:
          _controller = VideoPlayerController.asset(widget.source,videoPlayerOptions: widget.videoPlayerOptions);
        break;
      case SourceType.File:
          _controller = VideoPlayerController.file(File(widget.source),videoPlayerOptions: widget.videoPlayerOptions);
        break;
      case SourceType.Network:
          _controller = VideoPlayerController.network(widget.source,videoPlayerOptions: widget.videoPlayerOptions);
        break;
      default:
    }
    _controller.addListener(() {setState(() {
     }); });
    _initialiser = _controller.initialize().then((value) {
      setState(() {
        _aspectRatio = _controller.value.aspectRatio;
      });
    });
    if(widget.autoPlay){_controller.play();}
    if(widget.muteOnPlay){_controller.setVolume(0);}

    if(widget.getController != null){
      widget.getController(_controller);
    }

    Screen.brightness.then((value) {
      setState(() {
        _currentBrightness = value;
      });
    });

    _videoViewTheme = widget.videotheme == null?new VideoViewTheme():widget.videotheme;
  }

  String get _totalTime{
    Duration duration = _controller.value.duration;
    return duration.inHours==0?duration.inMinutes==0?"00:${duration.inSeconds.toString().padLeft(2,'0')}":"${duration.inMinutes.toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}":"${duration.inHours.toString().padLeft(2,'0')}:${(duration.inMinutes-(duration.inHours*60)).floor().toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}";
  }

  String get _currentTime{
    Duration duration = _controller.value.position;
    return duration.inHours==0?duration.inMinutes==0?"00:${duration.inSeconds.toString().padLeft(2,'0')}":"${duration.inMinutes.toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}":"${duration.inHours.toString().padLeft(2,'0')}:${(duration.inMinutes-(duration.inHours*60)).floor().toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}";
  }

  String get _remainTime{
    Duration duration = _controller.value.duration - _controller.value.position;
    return "-" + (duration.inHours==0?duration.inMinutes==0?"00:${duration.inSeconds.toString().padLeft(2,'0')}":"${duration.inMinutes.toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}":"${duration.inHours.toString().padLeft(2,'0')}:${(duration.inMinutes-(duration.inHours*60)).floor().toString().padLeft(2,'0')}:${(duration.inSeconds-(duration.inMinutes*60)).floor().toString().padLeft(2,'0')}");
  }
  //dispose
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  //_btn_resolution
  void _btn_resolution(){
    switch(_resolution){
      case 0:
        //Fill-Width
        _aspectRatio = _controller.value.aspectRatio;
        _zoomerState.setScale = 1.0;
      break;
      case 1:
        //100%
        _aspectRatio = _controller.value.aspectRatio;
        _zoomerState.setScale = _scale100;
      break;
      case 2:
        //Fill
        _zoomerState.setScale = 1.0;
      break;
      case 3:
        //Fill-Height
        _aspectRatio = _controller.value.aspectRatio;
        _zoomerState.setScale = _scaleHeight;
      break;
    }
    setState(() {    });
    _resolution+=1;
    if(_resolution==4){
      _resolution=0;
    }
  }
  //_btn_back
  void _btn_back(){
    if(widget.onBackClick == null){return;}
    widget.onBackClick();
  }
  //_btn_play
  void _btn_play(){
    if(!_controller.value.isPlaying){
      _controller.play();
    }
    else{
      _controller.pause();
    }
    setState(() {      
    });
  }
  //_btn_next
  void _btn_next(){
    if(widget.onNextClick == null){return;}
    widget.onNextClick();
  }
  //_btn_lock
  void _btn_lock(){
    _toggleFullscreen();
    _lockOpacity = !_lockOpacity;

    if(!_lockOpacity){
    Future.delayed(widget.hideShowDuration,(){
      setState(() {
        _locked = !_locked;
      });
    });}
    else{
      Future.delayed(Duration(seconds: 5),(){
        if(_locked && _lockOpacity){
        setState(() {
          _lockOpacity = false;
        });
        }
      });
      _locked = !_locked;
    }
    setState(() {
    });
  }
  //_toggleFullscreen
  void _toggleFullscreen(){
    _opacity = !_opacity;

    if(!_opacity){
    if(_timer!=null){_timer.cancel();}
    _timer = Timer(widget.hideShowDuration,(){
      setState(() {
        _fullscreen = !_fullscreen;
      });
    });}
    else{
      _fullscreen = !_fullscreen;
    }
    setState(() {
    });
  }
  //_hDragStart
  void _hDragStart(DragStartDetails details){
    if(_fullscreen){
      _toggleFullscreen();
    }
    _startHdrag = details.globalPosition.dx;
    _startDuration = _controller.value.position;
  }
  //_hDragUpdate
  void _hDragUpdate(DragUpdateDetails details){
    double delta = details.globalPosition.dx - _startHdrag;
    _controller.seekTo(_startDuration+Duration(seconds: (delta*widget.scrubDragConstant).floor()));
  }
  //_hDragEnd
  void _hDragEnd(DragEndDetails details){
  }
  //_vDragStart
  void _vDragStart(DragStartDetails details){
    _startVdrag = details.globalPosition.dy;
    _volumeChange = details.localPosition.dx/_videoWidth>0.5;
    _startVolume = _controller.value.volume;
    _volumeOpacity = _volumeChange?!_volumeOpacity:_volumeOpacity;
    _startBrightness = _currentBrightness;
    _brightnessOpacity = !_volumeChange?!_brightnessOpacity:_brightnessOpacity;
  }
  //_vDragUpdate
  void _vDragUpdate(DragUpdateDetails details){    
    double delta = details.globalPosition.dy - _startVdrag;
    if(_volumeChange){
      _controller.setVolume(_startVolume-delta*widget.volumeDragConstant);
    }
    else{
      _currentBrightness = (_startBrightness-delta*widget.volumeDragConstant).clamp(0.0, 1.0);
      Screen.setBrightness(_currentBrightness);
      setState(() { });
    }
  }
  //_vDragEnd
  void _vDragEnd(DragEndDetails details){
    setState(() {
      _volumeOpacity = _volumeChange?!_volumeOpacity:_volumeOpacity;
      _brightnessOpacity = !_volumeChange?!_brightnessOpacity:_brightnessOpacity;
    });
  }

  //build
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialiser,
      builder:(c,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
        return GestureDetector(
          onTap: (){if(!_locked){_toggleFullscreen();}else{
            if(!_lockOpacity){
              setState(() {
              _lockOpacity = true;
            });
            if(_timer!=null){_timer.cancel();}
            _timer = Timer(Duration(seconds: 5),(){
              if(_lockOpacity&&_locked){
              setState(() {
                _lockOpacity = false;
              });}
            });
            }
          }},
          onHorizontalDragStart: (details){if(!_locked){ _hDragStart(details); }},
          onHorizontalDragUpdate: (details){if(!_locked){ _hDragUpdate(details); }},
          onHorizontalDragEnd: (details){if(!_locked){ _hDragEnd(details); }},
          onVerticalDragStart: (details){if(!_locked){ _vDragStart(details); }},
          onVerticalDragUpdate: (details){if(!_locked){ _vDragUpdate(details); }},
          onVerticalDragEnd: (details){if(!_locked){ _vDragEnd(details); }},
            child: LayoutBuilder(
              builder:(con,mySize){
              double w = widget.width!=null?widget.width:mySize.biggest.width;
              _videoWidth = w;
              double h = widget.height!=null?widget.height:w/_aspectRatio;
              _scale100 = _controller.value.size.width/w;
              _scaleHeight = h/(w/_controller.value.aspectRatio);
              if(_resolution==3 && widget.height!=null){
                _aspectRatio = mySize.biggest.width/widget.height;
              }
              return Container(color: _videoViewTheme.backgroundColor,height:h,width: w,child: Stack(children: [
              Center(child: Zoomer(background: BoxDecoration(color:_videoViewTheme.backgroundColor),maxScale: widget.maxZoomScale,minScale: widget.minZoomScale,controller: _zoomerState,height: h,width: w,child: Center(child: AspectRatio(aspectRatio: _aspectRatio,child: VideoPlayer(_controller))))),
              Align(alignment: Alignment.centerLeft,child: 
                AnimatedOpacity(opacity: _volumeOpacity?1.0:0.0,duration: widget.hideShowDuration,child: Padding(padding: EdgeInsets.only(left: 20),child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [CircleAvatar(backgroundColor: _videoViewTheme.volumeBarFillColor,child: Icon(_controller.value.volume==0?Icons.volume_off:Icons.volume_up,color: _videoViewTheme.iconColor,)),Padding(padding: EdgeInsets.only(bottom: 10)),RotatedBox(quarterTurns: 3,child: SizedBox(height: 10,width: h/3,child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(_videoViewTheme.volumeBarFillColor),backgroundColor: _videoViewTheme.volumeBarEmptyColor,value: _controller.value.volume,)))]))),),
              Align(alignment: Alignment.centerLeft,child: 
                AnimatedOpacity(opacity: _lockOpacity?1.0:0.0,duration: widget.hideShowDuration,child: Padding(padding: EdgeInsets.only(left: 20),child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(blurRadius: 3)]),child: Material(color: _videoViewTheme.foregroundColor,child: Visibility(visible: _locked,child: InkWell(onTap: 
                (){if(_locked&&_lockOpacity){_btn_lock();}else{
                            if(!_lockOpacity){
                              setState(() {
                              _lockOpacity = true;
                            });
                            if(_timer!=null){_timer.cancel();}
                            _timer = Timer(Duration(seconds: 5),(){
                              if(_lockOpacity&&_locked){
                              setState(() {
                                _lockOpacity = false;
                              });}
                            });
                            }
                          }},child: Padding(padding: EdgeInsets.all(10),child: Icon(Icons.lock))))))]))),),
              Align(alignment: Alignment.centerRight,child: 
                AnimatedOpacity(opacity: _brightnessOpacity?1.0:0.0,duration: widget.hideShowDuration,child: Padding(padding: EdgeInsets.only(right: 20),child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [CircleAvatar(backgroundColor: _videoViewTheme.brightnessBarFillColor,child: Icon(Icons.brightness_5,color: _videoViewTheme.iconColor,)),Padding(padding: EdgeInsets.only(bottom: 10)),RotatedBox(quarterTurns: 3,child: SizedBox(height: 10,width: h/3,child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(_videoViewTheme.brightnessBarFillColor),backgroundColor: _videoViewTheme.brightnessBarEmptyColor,value: _currentBrightness,)))]))),),
              AnimatedOpacity(
                duration: widget.hideShowDuration,
                opacity: _opacity?1.0:0.0,
                child: Visibility(
                  visible: !_fullscreen,
                  child: Stack(
                    children: [
                      Align(alignment: Alignment.topCenter,child: GestureDetector(onTap: (){},
                        child: Container(width: w,height: 50,color: _videoViewTheme.foregroundColor,child:
                        Stack(children: <Widget>[
                          Align(alignment: Alignment.centerLeft,child: widget.leading),
                          Align(alignment: Alignment.center,child: widget.title==null?SizedBox(height:30,child: FittedBox(child: Text(_controller.dataSource.split("/").last,style: TextStyle(color: _videoViewTheme.textColor),))):widget.title,),
                          Align(alignment: Alignment.centerRight,child: widget.tailing,)
                          ],) 
                        ,),
                      ),),
                      Align(alignment: Alignment.bottomCenter,child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        height: 90,
                        color:_videoViewTheme.foregroundColor,
                        child: Column(mainAxisAlignment: MainAxisAlignment.end,children: [
                        LayoutBuilder(builder:(c,size)=>Container(color: Colors.transparent,child: Row(children: [Container(padding: EdgeInsets.only(left:5,right:5),width: 50,child: FittedBox(child: Text(_currentTime,style: TextStyle(color: _videoViewTheme.textColor),))),SizedBox(width: size.biggest.width-100,child: VideoProgressIndicator(_controller,colors: VideoProgressColors(playedColor: _videoViewTheme.timeBarFillColor,backgroundColor: _videoViewTheme.timeBarEmptyColor),allowScrubbing: true,)),Container(width: 50,padding: EdgeInsets.only(left:5,right:5),child: 
                          GestureDetector(onTap: (){setState(() { _showRemainTime = !_showRemainTime; });},child: FittedBox(child: Text( _showRemainTime?_remainTime:_totalTime,style: TextStyle(color: _videoViewTheme.textColor),))))]))),
                          Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(10),
                            child: Material(
                              color: Colors.transparent,
                              child: LayoutBuilder(
                                builder:(c,size){
                                  double _width = size.biggest.width/6;
                                  return Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                                  InkWell(splashColor: _videoViewTheme.iconColor,onTap: _btn_lock,child:Container(width: _width,padding: EdgeInsets.all(10),child: Icon(Icons.lock,color: _videoViewTheme.iconColor,))),
                                  InkWell(splashColor: _videoViewTheme.iconColor,onTap: _btn_back,child:Container(width: _width,padding: EdgeInsets.all(10),child: Icon(Icons.skip_previous,color: _videoViewTheme.iconColor))),
                                  InkWell(splashColor: _videoViewTheme.iconColor,onTap: _btn_play,child:Container(width: _width,padding: EdgeInsets.all(10),child: !_controller.value.isPlaying?Icon(Icons.play_arrow,color: _videoViewTheme.iconColor):Icon(Icons.pause,color: _videoViewTheme.iconColor))),
                                  InkWell(splashColor: _videoViewTheme.iconColor,onTap: _btn_next,child:Container(width: _width,padding: EdgeInsets.all(10),child: Icon(Icons.skip_next,color: _videoViewTheme.iconColor))),
                                  InkWell(splashColor: _videoViewTheme.iconColor,onTap: _btn_resolution,child:Container(width: _width,padding: EdgeInsets.all(10),child: _resolution==0?Icon(Icons.crop,color: _videoViewTheme.iconColor):_resolution==1?Icon(Icons.crop_16_9,color: _videoViewTheme.iconColor):_resolution==2?Icon(Icons.zoom_out_map,color: _videoViewTheme.iconColor):Icon(Icons.crop_free,color: _videoViewTheme.iconColor))),
                                ],);},
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ))],
                  ),
                ),
              ),
              ]));},
            ),
        );
        }
        else{
          return CircularProgressIndicator();
        }
        });
  }
}
