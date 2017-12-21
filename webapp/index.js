import 'babel-polyfill';
import Koa from 'koa';

const serve = require('koa-static');
const app = new Koa();
const Pug = require('koa-pug');
const pug = new Pug({
    layout: 'layout',
    viewPath: './views',
    basedir: './views'
});
const router = require('koa-router')();

// load middlewares
pug.use(app)
app.use(router.routes());
app.use(serve(__dirname + '/static/'));

router.get('/', async (ctx, next) => {
  ctx.render('index', {name: 'koa@2'});
})

app.listen(process.env.PORT || 5000);