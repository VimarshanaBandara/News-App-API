import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles =  new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    categories = getCategories();
    getNews();
  }


   getNews()async
   {
     News newsClass = News();
     await newsClass.getNews();
     articles = newsClass.news;
     setState(() {
       _loading = false;
     });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text('News',style: TextStyle(color: Colors.blue),)
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading ?Center(
        child:  Container(
          child: CircularProgressIndicator(),
        ) ,
      ): SingleChildScrollView(
        child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child:Column(
            children: [
              Container(
                height: 70.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  shrinkWrap: true,
                  itemBuilder: (context ,index)
                  {
                    return CategoryCard(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                  },

                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder:(context , index){
                      return BlogCard(
                        imageUrl:articles[index].urlToImage,
                        title: articles[index].title,
                        description: articles[index].description,
                        url: articles[index].url,
                      );
                    }

                ),
              )
            ],
          ) ,
        ),
      )
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String categoryName;
  CategoryCard({this.imageUrl , this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoryNews(
          category: categoryName.toString().toLowerCase(),
        )));
      },

      child:  Container(
        margin: EdgeInsets.only(right: 16.0),
        child: Stack(
          children: [
            ClipRRect(
              child: CachedNetworkImage(imageUrl:imageUrl,width: 120.0,height: 60.0,fit: BoxFit.cover,),
              borderRadius: BorderRadius.circular(6.0),
            ),
            Container(
              alignment: Alignment.center,
              width: 120.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.black26,
              ),

              child: Text(categoryName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500 , fontSize: 14.0),),
            )
          ],
        ),
      ),
    );
  }
}


class BlogCard extends StatelessWidget {

  final String imageUrl , title , description , url;
  BlogCard({@required this.imageUrl ,@required this.title ,@required this.description, @required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ArticleView(
         blogUrl: url,
        )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(imageUrl),
            ),
            SizedBox(height: 8.0,),
            Text(title,style: TextStyle(fontSize: 18.0,color: Colors.black87,fontWeight: FontWeight.w600),),
            SizedBox(height: 8.0,),
            Text(description,style: TextStyle(color: Colors.black54),),

          ],
        ),
      ),
    );
  }
}

