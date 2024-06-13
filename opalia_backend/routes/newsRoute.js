const express = require("express");
const Newsapp = express.Router();
const News = require("../models/news.model");
const upload = require("../middleware/upload");
const axios = require("axios");
const puppetire = require("puppeteer");
const cherrio = require("cheerio");
const request = require("request-promise");

const URL = "https://www.opaliarecordati.com/fr/articles";
// (async () => {
//   const response = await request(URL);
//   //console.log(response);
//   let i = cherrio.load(response);
//   let title = i("div.bloc_left.left > ul > li > a").text();
//   console.log(title);
// })();
let browserInstance;

// Function to initialize the browser instance
const initializeBrowser = async () => {
  browserInstance = await puppetire.launch({
    headless: false,
    defaultViewport: null,
  });
};

// Initialize the browser instance when the server starts
initializeBrowser();
const fetchData = async () => {
  try {
    const page = await browserInstance.newPage();
    await page.goto(URL, { waitUntil: "networkidle2" });
    const newsHandles = await page.$$(
      "div.inter_categorie.page-conseils > div.bloc3"
    );
    for (const newshandle of newsHandles) {
      const newstitle = await page.evaluate(
        (el) => el.querySelector("a > div.image_cat > div").textContent,
        newshandle
      );
      const newsDescription = await page.evaluate(
        (el) => el.querySelector("div.cat_description").textContent,
        newshandle
      );
      const newsImage = await page.evaluate(
        (el) => el.querySelector("a > div.image_cat > img").getAttribute("src"),
        newshandle
      );
      let articlesSaved = 0;
      let duplicateArticles = 0;
      const newsArticle = new News({
        newsTitle: newstitle,
        newsDetail: newsDescription,
        newsImage: newsImage,
        newsAuthor: "Unknown", // Modify if the author is available
        categorienews: "Unknown", // Modify if the category is available
      });
      console.log("scrape news succes");
      try {
        await newsArticle.save();
        articlesSaved++;
      } catch (error) {
        if (error.code === 11000) {
          duplicateArticles++;
        } else {
          console.error("Error saving article:", error);
        }
      }
    }
    await browserInstance.close();
    // res.status(200).json({
    //   message: "Scraping completed",
    //   articlesSaved,
    //   duplicateArticles,
    // });
  } catch (e) {
    console.log(e);
    //res.status(500).json({ error: "An error occurred during scraping" });
  }
  // try {

  //   let res = await axios.get(URL);
  //   let $ = cherrio.load(res.data);
  //   $("div.bloc_left.left > ul > li > a").each((i, e) => {
  //     newsss.push($(e).text().trim());
  //     console.log(newsss);
  //   });
  // } catch (e) {
  //   console.log(e);
  // }
};

Newsapp.get("/", async (req, res) => {
  try {
    const allNews = await News.find();
    //fetchData();
    res.status(200).json(allNews);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
Newsapp.get("/:categorienews", async (req, res) => {
  try {
    const categorienews = req.params.categorienews;
    const allNews = await News.find({ categorienews });
    res.status(200).json(allNews);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
Newsapp.post("/new", upload.single("newsImage"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const path = req.file.path.replace(/\\/g, "/");
    const imageUrl = `${req.protocol}://10.0.2.2:3001/${path}`;
    const news = new News({
      newsAuthor: req.body.newsAuthor,
      newsTitle: req.body.newsTitle,
      newsDetail: req.body.newsDetail,
      newsImage: imageUrl,
      newsPublication: req.body.newsPublication,
      categorienews: req.body.categorienews,
    });
    const newNews = await news.save();
    res.status(200).json({ date: newNews });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
Newsapp.delete("/delete/:id", getNews, async (req, res) => {
  try {
    await res.news.deleteOne();
    res.status(200).json({ message: "Delete news" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
Newsapp.put("/update/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const newNews = await News.findByIdAndUpdate(id, req.body);
    if (!newNews) {
      res.status(404).json({ message: `cannot find news with ID ${id}` });
    }
    res.status(200).json({ newNews });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
//middleware
async function getNews(req, res, next) {
  try {
    news = await News.findById(req.params.id);
    if (news == null) {
      return res.status(404).json({ message: "cant find News" });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
  res.news = news;
  next();
}

module.exports = Newsapp;
