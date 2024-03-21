const express = require("express");
const app = express.Router();
const News = require("../models/news.model");

app.get("/", async (req, res) => {
  try {
    const allNews = await News.find();
    res.status(200).json(allNews);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/new", async (req, res) => {
  const news = new News({
    newsAuthor: req.body.newsAuthor,
    newsTitle: req.body.newsTitle,
    newsDetail: req.body.newsDetail,
    newsImage: req.body.newsImage,
    newsPublication: req.body.newsPublication,
  });
  try {
    const newNews = await news.save();
    res.status(200).json({ date: newNews });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.delete("/delete/:id", getNews, async (req, res) => {
  try {
    await res.news.deleteOne();
    res.status(200).json({ message: "Delete medicament" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.patch("/update/:id", getNews, async (req, res) => {
  try {
    const newNews = await News.updateOne();
    res.status(200).json({ newNews });
  } catch (err) {
    res.status(400).json({ message: err.message });
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

module.exports = app;
