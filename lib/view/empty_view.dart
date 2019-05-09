import "package:flutter/material.dart";

class EmptyView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.directions_car,size: 50,color: Colors.black26,),
          SizedBox(height: 10.0,),
          Text("暂无数据",style: TextStyle(
            color: Colors.black26,
            fontSize: 16,
            fontWeight: FontWeight.normal
          ),)
        ],
      ),
    );
  }

}

