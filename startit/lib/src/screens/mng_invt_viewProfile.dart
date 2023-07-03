import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class MIViewProfile extends StatefulWidget {
  final int userId;
  final String email;
  final String phNumber;
  final String insName;

  MIViewProfile(this.userId, this.email, this.phNumber, this.insName);
  @override
  _MIViewProfileState createState() => _MIViewProfileState();
}

class _MIViewProfileState extends State<MIViewProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Color color;
  String image = "";
  String dob = "";
  String location = "";

  String categories = "";
  String subCategories = "";
  String microCategories = "";
  String question = "";

  String runningBusinessCategories = "";
  String investedProjects = "";
  String message = "";
  List<String> imageUrlPic = [];
  List<String> documentUrl = [];
  List<VideoPlayerController> _controller = [];
  List<String> documentUrl1 = [];
  List<String> imageUrlPic1 = [];
  List<VideoPlayerController> _controller1 = [];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    getProfileData();
    // getInterestsData();
    // getCapabilitiesData();
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  @override
  void dispose() {
    _controller.forEach((element) {
      element.dispose();
    });
    _controller1.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: height,
        color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          padding: EdgeInsets.all(width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "http://164.52.192.76:8080/startit/$image",
                        ),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: width * 0.08,
                        ),
                        Text(
                          widget.insName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  height: height * 0.55,
                  child: nestedTabs(height),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nestedTabs(double height) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            child: new SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelPadding: EdgeInsets.all(10.0),
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3.0,
                    tabs: [
                      Text(
                        "About",
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        "Interest Idea",
                        style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        "Capabilities",
                        style: TextStyle(
                            color: _tabController.index == 2
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            about(),
            interestIdea(),
            capabilities(),
            //edit(),
          ],
        ),
      ),
    );
  }

  Widget about() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PHONE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: _launchCaller,
                    child: Text(
                      "(+91) ${widget.phNumber}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "EMAIL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      widget.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATE  OF  BIRTH",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    dob,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "LOCATION",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _launchCaller() async {
    String url = "tel:+91${widget.phNumber}";
    await launch(url);
  }

  Widget interestIdea() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "IDEA CATEGORIES",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                categories,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "IDEA SUB-CATEGORIES",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                subCategories,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "IDEA MICRO-CATEGORY",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                microCategories,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "QUESTIONNAIRES",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                question,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              imageUrlPic1.length == 0
                  ? addPictures(
                      'Pictures',
                      'jpeg/png',
                      '',
                      Icon(Icons.photo),
                    )
                  : addPictures(
                      'Pictures',
                      'jpeg/png',
                      '',
                      GestureDetector(
                        onTap: () {
                          return showDialogFunc(context, imageUrlPic1);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (imageUrlPic1.length == 1)
                              ? Image.network(
                                  "http://164.52.192.76:8080/startit/" +
                                      imageUrlPic1[0],
                                  fit: BoxFit.contain,
                                )
                              : Row(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic1[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic1.length - 1)
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "VIDEOS",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              _controller1.length == 0
                  ? addPictures(
                      'Video',
                      'mp4',
                      '',
                      Icon(Icons.video_call_outlined
                          //color: Colors.white,

                          ),
                    )
                  : addPictures(
                      'Video',
                      'mp4',
                      '',
                      GestureDetector(
                        onTap: () {
                          return showDialogFuncVideo(context, _controller1);
                        },
                        child: Container(
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller1.length == 1)
                              ? _controller1[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller1[0].value.aspectRatio,
                                      child: VideoPlayer(_controller1[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller1[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller1[0]
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                    _controller1[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller1.length - 1)
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "DOCUMENTS",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              GestureDetector(
                onTap: () {
                  if (documentUrl1.isNotEmpty)
                    return showDialogFuncDocument(context, documentUrl1);
                },
                child: addPictures(
                  'Documents',
                  'pdf/dox/pptx',
                  '',
                  Row(
                    children: [
                      Container(
                        width: width * 0.06,
                        child: Icon(
                          Icons.insert_drive_file,
                          size: width * 0.04,
                          //color: Colors.white,
                        ),
                      ),
                      Center(
                          child: Text(
                        "+" + documentUrl1.length.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget capabilities() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "RUNNING BUSINESS CATEGORY",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                runningBusinessCategories,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "INVESTED PROJECTS",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                investedProjects,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "MESSAGE",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "PICTURES",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              imageUrlPic.length == 0
                  ? addPictures(
                      'Pictures',
                      'jpeg/png',
                      '',
                      Icon(Icons.photo),
                    )
                  : addPictures(
                      'Pictures',
                      'jpeg/png',
                      '',
                      GestureDetector(
                        onTap: () {
                          return showDialogFunc(context, imageUrlPic);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (imageUrlPic.length == 1)
                              ? Image.network(
                                  "http://164.52.192.76:8080/startit/" +
                                      imageUrlPic[0],
                                  fit: BoxFit.contain,
                                )
                              : Row(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic.length - 1).toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "VIDEOS",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              _controller.length == 0
                  ? addPictures(
                      'Video',
                      'mp4',
                      '',
                      Icon(Icons.video_call_outlined
                          //color: Colors.white,

                          ),
                    )
                  : addPictures(
                      'Video',
                      'mp4',
                      '',
                      GestureDetector(
                        onTap: () {
                          return showDialogFuncVideo(context, _controller);
                        },
                        child: Container(
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller.length == 1)
                              ? _controller[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller[0].value.aspectRatio,
                                      child: VideoPlayer(_controller[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller[0]
                                                    .value
                                                    .aspectRatio,
                                                child:
                                                    VideoPlayer(_controller[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller.length - 1).toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "DOCUMENTS",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              GestureDetector(
                onTap: () {
                  if (documentUrl.isNotEmpty)
                    return showDialogFuncDocument(context, documentUrl);
                },
                child: addPictures(
                  'Documents',
                  'pdf/dox/pptx',
                  '',
                  Row(
                    children: [
                      Container(
                        width: width * 0.06,
                        child: Icon(
                          Icons.insert_drive_file,
                          size: width * 0.04,
                          //color: Colors.white,
                        ),
                      ),
                      Center(
                          child: Text(
                        "+" + documentUrl.length.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addPictures(String txt, String txt1, String txt2, Widget icon) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        SizedBox(height: height * 0.005),
        Container(
          width: width * 0.14,
          height: height * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: icon,
        ),
        SizedBox(height: height * 0.005),
        Text(
          txt1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        Text(
          txt2,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        SizedBox(height: height * 0.01),
      ],
    );
  }

  void getProfileData() async {
    Map mapData = {"user_id": widget.userId};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_PROFILE),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        Map data =
            WebResponseExtractor.filterWebData(response, dataObject: "DETAILS");
        var userData = data["data"];

        setState(() {
          image = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          dob = userData["dob"] != null
              ? DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(userData["dob"]))
              : "";
          location = "${userData["city_name"]}, ${userData["state_name"]}";
        });
      }
    }
    getInvesterData();
  }

  void getInvesterData() async {
    Map mapData = {"user_id": widget.userId};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_INVESTOR_PROFILE),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "INS_IDEA");
        var investorData = data["data"];

        Map capabilitiesData = WebResponseExtractor.filterWebData(response,
            dataObject: "INS_CAPABILITIES");
        var capabilitesInfo = capabilitiesData["data"];
        print(capabilitesInfo["cap_media"]);
        print(investorData["INS_MEDIA"]);
        // Map data1 = WebResponseExtractor.filterWebData(capabilitiesData,
        //     dataObject: "cap_media");
        getIdeasFromWeb(capabilitesInfo["cap_media"]);
        getIdeasFromWeb1(investorData["INS_MEDIA"]);

        categories = investorData["mst_idea_category_id"] != ""
            ? investorData["idea_category_data"].first["category_name"]
            : "";
        subCategories = investorData["mst_idea_sub_category_id"] != ""
            ? investorData["idea_sub_category"].first["sub_category"]
            : "";
        microCategories = investorData["mst_fall_sub_cat_id"] != ""
            ? investorData["idea_fall_category_data"].first["fall_cat_name"]
            : "";

        setState(() {
          question = investorData["question"] != null
              ? investorData["question"]
              : "No Questions";
          investedProjects = capabilitesInfo["mst_ins_projects_id"] != null
              ? capabilitesInfo["mst_ins_projects_id"]
              : "";
          message = capabilitesInfo["message"] != null
              ? capabilitesInfo["message"]
              : "";

          runningBusinessCategories = investorData["running_category_name"]
                      .first["running_category_name"] !=
                  null
              ? investorData["running_category_name"]
                  .first["running_category_name"]
              : "";
        });
      }
    }
  }

  Future<void> getIdeasFromWeb1(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageUrlPic1.add(idea["picture_path"]);
        }
        // File.writeAsBytes(response.bodyBytes);
        else if (idea["file_type_head"] == "video") {
          if (idea["picture_path"] != null && idea["picture_path"] != "") {
            VideoPlayerController vdioe;
            vdioe = VideoPlayerController.network(
                "http://164.52.192.76:8080/startit/" + idea["picture_path"])
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {
                  // vdioe.play();
                });
              });
            _controller1.add(vdioe);
          }
        } else if (idea["file_type_head"] == "document") {
          documentUrl1
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
    });
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageUrlPic.add(idea["picture_path"]);
        }
        // File.writeAsBytes(response.bodyBytes);
        else if (idea["file_type_head"] == "video") {
          if (idea["picture_path"] != null && idea["picture_path"] != "") {
            VideoPlayerController vdioe;
            vdioe = VideoPlayerController.network(
                "http://164.52.192.76:8080/startit/" + idea["picture_path"])
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {
                  // vdioe.play();
                });
              });
            _controller.add(vdioe);
            // _controller.add(VideoPlayerController.network(
            //     "http://164.52.192.76:8080/startit/" + idea["picture_path"]));
          }
        } else if (idea["file_type_head"] == "document") {
          documentUrl
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
    });
  }
}
showDialogFuncVideo(context, List<VideoPlayerController> vc) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vc.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: vc.length == 1
                                ? MediaQuery.of(context).size.width * 0.95
                                : MediaQuery.of(context).size.width * 0.8,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: vc[index].value.initialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            vc[index].value.aspectRatio,
                                        child: VideoPlayer(vc[index]),
                                      )
                                    : Container()),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 30,
                              icon: Icon(!vc[index].value.isPlaying
                                  ? Icons.play_arrow
                                  : Icons.pause),
                              onPressed: () {
                                !vc[index].value.isPlaying
                                    ? vc[index].play()
                                    : vc[index].pause();
                                setState(() {});
                                vc[index].setLooping(true);
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            ),
          ),
        );
      });
    },
  );
}

showDialogFuncDocument(context, List<String> img) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                itemBuilder: (BuildContext context, int index) {
                  String docType = img[index].split(".").last;
                  IconData customIcon;
                  Color clr;
                  if (docType == "pdf") {
                    customIcon = myIcons.MaterialCommunityIcons.pdf_box;
                    clr = Colors.red;
                  }
                  if (docType == "xlsx") {
                    customIcon = myIcons.MaterialCommunityIcons.file_excel_box;
                    clr = Colors.green[700];
                  }
                  if (docType == "docx" || docType == "doc") {
                    customIcon = myIcons.MaterialCommunityIcons.file_word_box;
                    clr = Colors.blue[700];
                  }
                  if (docType == "pptx") {
                    customIcon =
                        myIcons.MaterialCommunityIcons.file_powerpoint_box;
                    clr = Colors.orange[700];
                  }
                  print(docType);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              await launch(img[index]);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Icon(
                                customIcon,
                                color: clr,
                                size: 50,
                              ),
                            )),
                      ),
                    ],
                  );
                }),
          ),
        ),
      );
    },
  );
}

showDialogFunc(context, List<String> img) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            "http://164.52.192.76:8080/startit/" + img[index],
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // SizedBox(
                      //   height: MediaQuery.of(context).size.width * 0.5,
                      //   child: Divider(
                      //     thickness: 5,
                      //     color: Colors.black,
                      //   ),
                      // )
                    ],
                  );
                }),
          ),
        ),
      );
    },
  );
}