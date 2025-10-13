import 'package:flutter/material.dart';
import 'package:lam7a/models/tweet.dart';
import 'package:lam7a/models/user_profile.dart';
import 'package:lam7a/widgets/vedio_player.dart';
import 'package:video_player/video_player.dart';

class Tweet extends StatefulWidget {
  const Tweet({
    super.key,
    required this.tweetId,
    required this.user,
    required this.post,
    //required this.summerizeBody     ** waiting for it to finish to see if it will be passed or inpelmented in this class  
  });
  final UserProf user;
  final int tweetId;
  final Post post;
  //final void Function() summerizeBody;  ** waiting for it to finish to see if it will be passed or inpelmented in this class 
  @override
  State<Tweet> createState() {
    return _TweetState();
  }
}

class _TweetState extends State<Tweet> {
void _summerizeBody()
{

}
  
  @override
  Widget build(BuildContext context) {
    final daysPosted = DateTime.now().day - widget.post.date.day;
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        key: Key(widget.tweetId.toString()),
        color: Theme.of(context).colorScheme.onSurface,
        padding: EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 19, // size of the circle
                    backgroundImage: NetworkImage(widget.user.profilePic),
                    backgroundColor:
                        Colors.grey[200], // optional placeholder color
                  ),
                  SizedBox(width: 10, height: 5),
                  Text(
                    widget.user.username,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.user.hashUserName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('${daysPosted.toString()}d'),
                  SizedBox(width: 10),
                  IconButton(icon: Icon(Icons.rocket),onPressed:  _summerizeBody  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                widget.post.body,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 10),
              if(widget.post.mediaPic != null)
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.post.mediaPic.toString() ,
                          width: double.infinity ,
                          height: 200,
                          fit: BoxFit.cover,
                          
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                if(widget.post.mediaVideo != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoPlayerWidget(url:widget.post.mediaVideo.toString()),
                )
                  ],
                ),
              ),
            ],
        
        ),
      ),
    );
  }
}
