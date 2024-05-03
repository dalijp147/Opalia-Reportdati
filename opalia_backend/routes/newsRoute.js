const express = require("express");
const app = express.Router();
const News = require("../models/news.model");
const upload = require("../middleware/upload");
app.get("/", async (req, res) => {
  try {
    const allNews = await News.find();
    res.status(200).json(allNews);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.get("/:categorienews", async (req, res) => {
  try {
    const categorienews = req.params.categorienews;
    const allNews = await News.find({ categorienews });
    res.status(200).json(allNews);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.post("/new", upload.single("newsImage"), async (req, res) => {
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
app.delete("/delete/:id", getNews, async (req, res) => {
  try {
    await res.news.deleteOne();
    res.status(200).json({ message: "Delete news" });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});
app.put("/update/:id", async (req, res) => {
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

module.exports = app;
