# elm-pages-test

Elm and the elm architecture is the most logical and concise way to create web applications in my opinion. After listenting to the excellent [elm radio podcast](https://elm-radio.com/) I decided to try out [elm-pages v3](https://elm-pages.com/). This repo is that test.

## The goal

- Test how easy it is to create a hybrid site where parts are statically generated and parts are not
- See how easy it is to understand elm code written by someone else than me (I do not work professionally with elm)

## The plan

Since this is a test I have put everything in one repository. If this was something more than a test I would not.

1. Static pages will be generated for [content/articles](./content/articles)
2. A news page will load news from [content/news](./content/news)
3. Add form and send to database
4. Clean up starter project
5. Add [Tailwind CSS](https://tailwindcss.com/)
6. Rebuild when new article is added
7. Deployment
8. Internationalization

## Progress / Journal

### Static pages

Surprisingly easy to get started. Created a new route for articles and went from there. Working with `BackendTask` feels like a good fit for the problem. I realize that internalionalization would be interesting to implement also.

**Lessons**

- In production I would have separate repository for all content that should be pre-rendered
- Internalionalization would be interesting to implement
