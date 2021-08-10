import 'package:bordatech/utils/hex_color.dart';
import 'package:flutter/material.dart';

class TermsPrivacyPolicy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TermsPrivacyPolicyState();
  }
}

class _TermsPrivacyPolicyState extends State<TermsPrivacyPolicy> {
/*  String data = '';
   fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString("textFiles/terms.txt");

    SetState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Image.asset('assets/return.png')),
        title: Image.asset(
          "assets/borda.png",
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: bordaGreen,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: SingleChildScrollView(
          //backgroundColor: settingsBack,
          padding: const EdgeInsets.all(50),
          //backgroundColor: Colors.grey,
          child: new SingleChildScrollView(
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id neque venenatis erat sollicitudin tristique. Donec at felis dolor. Donec eget sem ut felis volutpat euismod. Morbi pulvinar urna sed condimentum bibendum. Nulla tempus, mi suscipit ullamcorper vestibulum, sapien tortor congue libero, sit amet vehicula quam erat in ex. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Etiam consequat risus ipsum, sit amet interdum nunc semper quis Curabitur rhoncus fringilla finibus. Aliquam fringilla, est in blandit molestie, dolor purus gravida enim, vitae mattis quam turpis quis turpis. In sed turpis quis tortor fringilla iaculis. Morbi faucibus ultrices nibh, id gravida risus ultricies vel. Curabitur vestibulum eget dui malesuada rhoncus. Pellentesque eu venenatis nulla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Curabitur eu auctor neque. Curabitur rutrum nisi id fringilla fringilla.Morbi varius ligula aliquam augue lacinia, ut blandit justo dignissim. Praesent erat augue, consectetur vel condimentum vitae, pulvinar vel ligula. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ultrices lobortis orci eget blandit. Praesent laoreet pulvinar justo, non commodo arcu tincidunt sit amet. Sed tempor accumsan tortor, sed pretium libero volutpat et. Vivamus id risus pellentesque, tempus enim at, consequat ex. Praesent vel lacus ligula. Nullam sollicitudin tempor ligula, nec posuere massa maximus vel. Vestibulum lobortis egestas dolor eu lobortis. Ut vitae nisl tempus, maximus mauris et, vulputate risus. Proin eget mollis purus. Curabitur purus tellus, pharetra sit amet fermentum quis, condimentum nec nisi. Nullam a scelerisque antMauris in ex eros. Nulla bibendum diam quis est pulvinar iaculis. Morbi pretium sit amet mi nec interdum. Fusce et accumsan enim. Pellentesque in ex in nisl ultrices convallis. Mauris lectus lorem, fermentum sit amet quam vel, bibendum ultrices metus. Sed eget justo eros. Cras lacinia dictum rutrum. In rutrum volutpat massa, ut semper nunc maximus eget. Nunc ac laoreet risus. Pellentesque dignissim, sem eu tincidunt molestie, nulla eros consequat erat, sed vestibulum nisl ipsum aliquet elit. Mauris venenatis dui vel tortor sollicitudin gravida.Sed eu enim risus. Praesent posuere eros nec porta auctor. Quisque quis nisl id ipsum varius ultricies. Donec faucibus tempor lobortis. In feugiat lorem in est porta pulvinar. Morbi finibus tortor eu suscipit congue. Suspendisse cursus tincidunt pulvinar. Sed porta quam vel risus semper pulvinar. Fusce laoreet eu ante ut egestas. Maecenas consequat mi vitae dolor vulputate, ac eleifend massa faucibus. Integer dolor purus, mattis ut faucibus nec, venenatis vitae purus. Praesent dolor tortor, laoreet id molestie et, dictum nec lectus. Donec dui mi, volutpat eu mattis sed, gravida et elit. Curabitur augue sem, aliquet non leo ut, euismod sodales magna. Nullam porta quis leo sit amet convallis.Sed eleifend consequat dignissim. Mauris urna urna, vestibulum a aliquam et, egestas in magna. Quisque consectetur sit amet nunc eu vestibulum. Vivamus a risus purus. Ut lobortis risus quis velit porttitor auctor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Suspendisse interdum, risus nec egestas aliquet, arcu ex tincidunt risus, sed commodo purus lorem eget ex.Cras ligula metus, consequat eu lacus in, auctor commodo nulla. Vestibulum dapibus quis risus vitae dapibus. Maecenas in nisi eu augue tincidunt pretium in at dui. Pellentesque convallis, lacus ut scelerisque auctor, mi tortor ultricies nulla, ac tincidunt tortor ante a turpis. Etiam suscipit quam ut neque vulputate condimentum vel eu turpis. Pellentesque tristique malesuada enim, nec ultricies lectus scelerisque quis. In congue, sem nec suscipit porta, sem nunc vehicula ex, quis convallis elit quam sed mi. Nullam non nulla eros. Phasellus in efficitur ipsum. Aliquam eget nisl sapien. Mauris a augue sit amet libero rhoncus hendrerit. Mauris volutpat, libero id tristique cursus, augue nisi eleifend odio, et interdum purus diam sit amet libero. Vestibulum at magna interdum, condimentum diam eu, imperdiet neque. Morbi non metus molestie, faucibus quam vitae, vulputate sem. Donec volutpat suscipit erat. Vivamus erat justo, ultrices sit amet pellentesque id, eleifend elementum risus. Ut lectus ligula, commodo non arcu eu, placerat iaculis mi. Mauris vel massa quam. Fusce pulvinar sit amet erat bibendum aliquam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam auctor, nunc in congue malesuada, odio augue bibendum quam, id mattis quam mi sed lacus. Duis et finibus arcu.ras tristique egestas urna, non pharetra justo pellentesque vitae. Nullam vel varius elit. Nunc ut felis gravida, dignissim erat at, ultrices metus. Sed a odio at nisi bibendum venenatis. Vivamus vulputate leo quis felis venenatis ullamcorper. Vivamus vehicula euismod elit. Donec tristique dolor at tempor rutrum. Integer rhoncus, lectus vitae mattis cursus, nisl nibh aliquam orci, ut consectetur enim ipsum et odio. Duis nunc ante, lacinia id nulla vel, pulvinar pellentesque velit. Sed nec dolor elit. Sed eget tincidunt libero, ut venenatis ipsum.Aenean non ante quis odio ornare sagittis sit amet a urna. Aenean at suscipit enim. Morbi convallis nisl risus. Nulla non eleifend risus. Proin imperdiet erat ligula, eget aliquam turpis ultrices eget. Suspendisse quis libero sapien. Duis dapibus elit ut tempus facilisis. Maecenas justo leo, pretium vestibulum vulputate quis, commodo quis ligula. Sed accumsan fringilla accumsan. Aliquam a justo maximus, iaculis nunc sit amet, accumsan eros"),
            /* child: Column(
                children: <Widget>[],
              ), */
            /*  child: new Text(
                "     Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce convallis pellentesque metus id lacinia. Nunc dapibus pulvinar auctor. Duis nec sem at orci commodo viverra id in ipsum. Fusce tellus nisl, vestibulum sed rhoncus at, pretium non libero. Cras vel lacus ut ipsum vehicula aliquam at quis urna. Nunc ac ornare ante. Fusce lobortis neque in diam vulputate quis semper sem elementum.", // Need this to be bold
                style: new TextStyle(color: Colors.black),
              ), */
          ),
        ),
      ),
    );
  }
}
