type request
type response

// open Js.Promise
// open Fetch

@new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@send
external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@get external response: request => response = "response"
@send external open_: (request, string, string) => unit = "open"
@send external send: request => unit = "send"
@send external abort: request => unit = "abort"

@get external status: request => int = "status"

module Api = {
  //   let addJwtToken: unit => array<(string, string)> = () =>
  //     Utils.getCookie("jwtToken")
  //     ->Belt.Option.flatMap(snd)
  //     ->Belt.Option.map(token => [("Authorization", Printf.sprintf("Token %s", token))])
  //     ->Belt.Option.getWithDefault([])

  //   let getDogs: unit => array<(string, string)> = () => [
  //     ("Content-Type", "application/json; charset=UTF-8"),
  //   ]

  @scope("JSON") @val
  external parseResponse: response => {"message": array<string>} = "parse"

  // XHR example (no dependencies)
  let getDogs = (~address, ~onDone, ~onError /* , () */) => {
    // let query = (~address) => {
    let request = makeXMLHttpRequest()

    request->addEventListener("load", () => onDone(request->response->parseResponse))
    request->addEventListener("error", () => onError(request->status))
    // request->addEventListener("load", () => {
    //   let response = request->response->parseResponse
    //   Js.log(response["message"])
    // })
    // request->addEventListener("error", () => {
    //   Js.log("Error logging here")
    // })

    request->open_("GET", "https://dog.ceo/api/breeds/image/random/" ++ address)
    request->send

    // () => request->abort
  }

  let getDogsAndPrint = () =>
    getDogs(
      ~address="3",
      ~onDone=response => {
        // let response = request->response->parseResponse
        Js.log2("GetDogsAndPrint Done", response["message"])
      },
      ~onError=x => {
        // let response = request->response->parseResponse
        Js.log("Error logging: " ++ Belt.Int.toString(x))
      },
    )

  let getDogsAndShow = (~show) =>
    getDogs(
      ~address="3",
      ~onDone=response => {
        // let response = request->response->parseResponse
        Js.log2("GetDogsAndShow Done", response["message"])
        show(response["message"])
      },
      ~onError=x => {
        // let response = request->response->parseResponse
        Js.log("Error logging: " ++ Belt.Int.toString(x))
      },
    )

  let result = [1, 2, 3]->Js.Array2.map(a => a + 1)->Js.Array2.filter(a => mod(a, 2) == 0)
  Js.log(result)

  // Working example of promise (with wildcards)
  let myPromise = Js.Promise.make((~resolve, ~reject as _) => resolve(. 2))
  let _ = myPromise->Js.Promise.then_(value => {
      Js.log2("prom1: ", value)
      Js.Promise.resolve(value + 2)
    }, _)->Js.Promise.then_(value => {
      Js.log2("prom2: ", value)
      Js.Promise.resolve(value + 3)
    }, _)->Js.Promise.catch(err => {
      Js.log2("Failure!!", err)
      Js.Promise.resolve(-2)
    }, _)

  // Using Fetch API with bs-fetch bindings
  // let getDogsFetch = () => Js.Promise.(
  //   Fetch.fetch("https://dog.ceo/api/breeds/image/random/1")
  //   |> then_(Fetch.Response.text)
  //   |> then_(text => print_endline(text) |> resolve),
  // )
  // Works:
  // let getDogsFetch = () =>
  //   Fetch.fetch("https://dog.ceo/api/breeds/image/random/1")->Js.Promise.then_(value => {
  //     Js.log2("getDogsFetch: ", value)
  //     Js.Promise.resolve(value)
  //   }, _)

  // Note: https://kevanstannard.github.io/rescript-blog/fetch-json.html
  // module Decode = {
  //   // open Json.Decode
  //   let catData = (data: Js.Json.t) => {
  //      file: Json.Decode.field("file", string, data),
  //   }
  // }

  // Note: https://medium.com/@kevanstannard/how-to-fetch-json-data-with-reasonml-a4507ec945ad
  let getDogsFetch = () =>
    "https://dog.ceo/api/breeds/image/random/1"
    ->Fetch.fetch
    // Fetch.fetch("https://dog.ceo/api/breeds/image/random/1")
    // ->Js.Promise.then_(Fetch.Response.text)
    ->Js.Promise.then_(value => {
      Js.log2("getDogsFetch: ", value)
      Js.Promise.resolve(value)
    }, _)

  // type data = {message: array<string>}

  // @scope("JSON") @val
  // external parseDogResponse: string => data = "parse"

  // let result = parseDogResponse(`{"message": ["Luke", "Christine"]}`)
  // let name1 = result.message[0]

  // let _ =
  //   getDogsFetch()
  //   |> Js.Promise.then_(Fetch.Response.json)
  //   |> Js.Promise.then_(x => Js.Promise.resolve(parseDogResponse))
  // // |> Js.Promise.then_(response => {
  // //   switch Js.Json.decodeObject(response) {
  // //   | Some(decodedRes) => Js.Promise.resolve(decodedRes)
  // //   | None => Js.Promise.resolve(Js.Dict.empty())
  // //   }
  // // })
  // |> Js.Promise.then_(response => {
  //   Js.log2("getDogsFetch2: ", response.message[0])
  //   Js.Promise.resolve(response.message[0])
  // })

  // let getDogsFetch = () => Js.Promise.(
  //   Fetch.fetch("https://dog.ceo/api/breeds/image/random/1")
  //   |> then_(Fetch.Response.text)
  //   |> then_(text => print_endline(text) |> resolve),
  // )

  // let getDogsFetch = () =>
  //   Fetch.fetch("https://dog.ceo/api/breeds/image/random/1")
  //   |> Js.Promise.then_(Fetch.Response.text)
  //   |> Js.Promise.then_(text => print_endline(text) |> Js.Promise.resolve)

  // let tags: unit => Js.Promise.t<result<Shape.Tags.t, AppError.t>> = () =>
  //   Endpoints.tags
  //   |> fetch
  //   |> then_(parseJsonIfOk)
  //   |> then_(getErrorBodyText)
  //   |> then_(result =>
  //     result->Belt.Result.flatMap(json => json->Shape.Tags.decode->AppError.decode)->resolve
  //   )
}

// TODO use Fetch
//
//
// module Action = {
//   type article =
//     | Create(Shape.Article.t)
//     | Read(string)
//     | Update(string, Shape.Article.t)
//     | Delete(string)

//   type follow =
//     | Follow(string)
//     | Unfollow(string)

//   type favorite =
//     | Favorite(string)
//     | Unfavorite(string)
// }

// module Headers = {
//   let addJwtToken: unit => array<(string, string)> = () =>
//     Utils.getCookie("jwtToken")
//     ->Belt.Option.flatMap(snd)
//     ->Belt.Option.map(token => [("Authorization", Printf.sprintf("Token %s", token))])
//     ->Belt.Option.getWithDefault([])

//   let addContentTypeAsJson: unit => array<(string, string)> = () => [
//     ("Content-Type", "application/json; charset=UTF-8"),
//   ]
// }

// let getErrorBodyJson: result<Js.Json.t, Response.t> => Js.Promise.t<
//   result<Js.Json.t, AppError.t>,
// > = x =>
//   switch x {
//   | Ok(_json) as ok => ok |> resolve
//   | Error(resp) =>
//     resp
//     |> Response.json
//     |> then_(json => {
//       let status = Response.status(resp)
//       let statusText = Response.statusText(resp)
//       let bodyJson = #json(json)

//       AppError.fetch((status, statusText, bodyJson))->Belt.Result.Error->resolve
//     })
//   }

// let getErrorBodyText: result<Js.Json.t, Response.t> => Js.Promise.t<
//   result<Js.Json.t, AppError.t>,
// > = x =>
//   switch x {
//   | Ok(_json) as ok => ok |> resolve
//   | Error(resp) =>
//     let status = Response.status(resp)
//     let statusText = Response.statusText(resp)
//     let bodyText = #text("FIXME: show body text instead")

//     AppError.fetch((status, statusText, bodyText))->Belt.Result.Error->resolve
//   }

// let parseJsonIfOk: Response.t => Js.Promise.t<result<Js.Json.t, Response.t>> = resp =>
//   if Response.ok(resp) {
//     resp
//     |> Response.json
//     |> then_(json => json->Ok->resolve)
//     |> catch(_error => resp->Belt.Result.Error->resolve)
//   } else {
//     resp->Belt.Result.Error->resolve
//   }

// let article: (
//   ~action: Action.article,
//   unit,
// ) => Js.Promise.t<result<Shape.Article.t, AppError.t>> = (~action, ()) => {
//   let body = switch action {
//   | Create(article) | Update(_, article) =>
//     let article =
//       list{
//         ("title", Js.Json.string(article.title)),
//         ("description", Js.Json.string(article.description)),
//         ("body", Js.Json.string(article.body)),
//         ("tagList", Js.Json.stringArray(article.tagList)),
//       }
//       |> Js.Dict.fromList
//       |> Js.Json.object_

//     list{("article", article)}
//     ->Js.Dict.fromList
//     ->Js.Json.object_
//     ->Js.Json.stringify
//     ->BodyInit.make
//     ->Some
//   | Read(_) | Delete(_) => None
//   }

//   let method__ = switch action {
//   | Create(_) => Post
//   | Read(_) => Get
//   | Update(_) => Put
//   | Delete(_) => Delete
//   }

//   let headers =
//     switch action {
//     | Create(_) | Update(_) => Headers.addContentTypeAsJson()
//     | Read(_) | Delete(_) => []
//     }
//     ->Belt.Array.concat(Headers.addJwtToken())
//     ->HeadersInit.makeWithArray

//   let slug = switch action {
//   | Create(_) => ""
//   | Read(slug) | Update(slug, _) | Delete(slug) => slug
//   }

//   fetchWithInit(
//     Endpoints.Articles.article(~slug, ()),
//     RequestInit.make(~method_=method__, ~headers, ~body?, ()),
//   )
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyJson)
//   |> then_(result => {
//     result
//     ->Belt.Result.flatMap(json => {
//       try {
//         json
//         ->Js.Json.decodeObject
//         ->Belt.Option.getExn
//         ->Js.Dict.get("article")
//         ->Belt.Option.getExn
//         ->Shape.Article.decode
//         ->AppError.decode
//       } catch {
//       | _ => AppError.decode(Error("API.article: failed to decode json"))
//       }
//     })
//     ->resolve
//   })
// }

// let favoriteArticle: (
//   ~action: Action.favorite,
//   unit,
// ) => Js.Promise.t<result<Shape.Article.t, AppError.t>> = (~action, ()) => {
//   let requestInit = RequestInit.make(
//     ~method_=switch action {
//     | Favorite(_slug) => Post
//     | Unfavorite(_slug) => Delete
//     },
//     ~headers=Headers.addJwtToken()->HeadersInit.makeWithArray,
//     (),
//   )

//   Endpoints.Articles.favorite(
//     ~slug=switch action {
//     | Favorite(slug) => slug
//     | Unfavorite(slug) => slug
//     },
//     (),
//   )
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result
//     ->Belt.Result.flatMap(json =>
//       try {
//         json
//         ->Js.Json.decodeObject
//         ->Belt.Option.getExn
//         ->Js.Dict.get("article")
//         ->Belt.Option.getExn
//         ->Shape.Article.decode
//         ->AppError.decode
//       } catch {
//       | _ => AppError.decode(Error("API.favoriteArticle: failed to decode json"))
//       }
//     )
//     ->resolve
//   )
// }

// let listArticles: (
//   ~limit: int=?,
//   ~offset: int=?,
//   ~tag: string=?,
//   ~author: string=?,
//   ~favorited: string=?,
//   unit,
// ) => Js.Promise.t<result<Shape.Articles.t, AppError.t>> = (
//   ~limit=10,
//   ~offset=0,
//   ~tag=?,
//   ~author=?,
//   ~favorited=?,
//   (),
// ) => {
//   let requestInit = RequestInit.make(~headers=Headers.addJwtToken()->HeadersInit.makeWithArray, ())

//   Endpoints.Articles.root(~limit, ~offset, ~tag?, ~author?, ~favorited?, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.Articles.decode->AppError.decode)->resolve
//   )
// }

// let feedArticles: (
//   ~limit: int=?,
//   ~offset: int=?,
//   unit,
// ) => Js.Promise.t<result<Shape.Articles.t, AppError.t>> = (~limit=10, ~offset=0, ()) => {
//   let requestInit = RequestInit.make(~headers=Headers.addJwtToken()->HeadersInit.makeWithArray, ())

//   Endpoints.Articles.feed(~limit, ~offset, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.Articles.decode->AppError.decode)->resolve
//   )
// }

// let tags: unit => Js.Promise.t<result<Shape.Tags.t, AppError.t>> = () =>
//   Endpoints.tags
//   |> fetch
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.Tags.decode->AppError.decode)->resolve
//   )

// let currentUser: unit => Js.Promise.t<result<Shape.User.t, AppError.t>> = () => {
//   let requestInit = RequestInit.make(~headers=Headers.addJwtToken()->HeadersInit.makeWithArray, ())

//   Endpoints.user
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.User.decode->AppError.decode)->resolve
//   )
// }

// let updateUser: (
//   ~user: Shape.User.t,
//   ~password: string,
//   unit,
// ) => Js.Promise.t<result<Shape.User.t, AppError.t>> = (~user, ~password, ()) => {
//   let user =
//     list{
//       list{("email", Js.Json.string(user.email))},
//       list{("bio", Js.Json.string(user.bio->Belt.Option.getWithDefault("")))},
//       list{("image", Js.Json.string(user.image->Belt.Option.getWithDefault("")))},
//       list{("username", Js.Json.string(user.username))},
//       if password == "" {
//         list{}
//       } else {
//         list{("password", Js.Json.string(password))}
//       },
//     }
//     |> List.flatten
//     |> Js.Dict.fromList
//     |> Js.Json.object_
//   let body =
//     list{("user", user)}
//     |> Js.Dict.fromList
//     |> Js.Json.object_
//     |> Js.Json.stringify
//     |> BodyInit.make

//   let requestInit = RequestInit.make(
//     ~method_=Put,
//     ~headers=Headers.addJwtToken()
//     ->Belt.Array.concat(Headers.addContentTypeAsJson())
//     ->HeadersInit.makeWithArray,
//     ~body,
//     (),
//   )

//   Endpoints.user
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyJson)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.User.decode->AppError.decode)->resolve
//   )
// }

// let followUser: (
//   ~action: Action.follow,
//   unit,
// ) => Js.Promise.t<result<Shape.Author.t, AppError.t>> = (~action, ()) => {
//   let requestInit = RequestInit.make(
//     ~method_=switch action {
//     | Follow(_username) => Post
//     | Unfollow(_username) => Delete
//     },
//     ~headers=Headers.addJwtToken()->HeadersInit.makeWithArray,
//     (),
//   )

//   Endpoints.Profiles.follow(
//     ~username=switch action {
//     | Follow(username) | Unfollow(username) => username
//     },
//     (),
//   )
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => {
//       try {
//         json
//         ->Js.Json.decodeObject
//         ->Belt.Option.getExn
//         ->Js.Dict.get("profile")
//         ->Belt.Option.getExn
//         ->Shape.Author.decode
//         ->AppError.decode
//       } catch {
//       | _ => AppError.decode(Belt.Result.Error("API.followUser: failed to decode json"))
//       }
//     }) |> resolve
//   )
// }

// let getComments: (
//   ~slug: string,
//   unit,
// ) => Js.Promise.t<result<array<Shape.Comment.t>, AppError.t>> = (~slug, ()) => {
//   let requestInit = RequestInit.make(~headers=Headers.addJwtToken()->HeadersInit.makeWithArray, ())

//   Endpoints.Articles.comments(~slug, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.Comment.decode->AppError.decode)->resolve
//   )
// }

// let deleteComment: (
//   ~slug: string,
//   ~id: int,
//   unit,
// ) => Js.Promise.t<result<(string, int), AppError.t>> = (~slug, ~id, ()) => {
//   let requestInit = RequestInit.make(
//     ~method_=Delete,
//     ~headers=Headers.addJwtToken()->HeadersInit.makeWithArray,
//     (),
//   )

//   Endpoints.Articles.comment(~slug, ~id, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result => result->Belt.Result.flatMap(_json => Belt.Result.Ok((slug, id)))->resolve)
// }

// let addComment: (
//   ~slug: string,
//   ~body: string,
//   unit,
// ) => Js.Promise.t<result<Shape.Comment.t, AppError.t>> = (~slug, ~body, ()) => {
//   let comment = list{("body", Js.Json.string(body))} |> Js.Dict.fromList |> Js.Json.object_

//   let body =
//     list{("comment", comment)}
//     |> Js.Dict.fromList
//     |> Js.Json.object_
//     |> Js.Json.stringify
//     |> BodyInit.make

//   let requestInit = RequestInit.make(
//     ~method_=Post,
//     ~headers=Headers.addJwtToken()
//     ->Belt.Array.concat(Headers.addContentTypeAsJson())
//     ->HeadersInit.makeWithArray,
//     ~body,
//     (),
//   )

//   Endpoints.Articles.comments(~slug, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result
//     ->Belt.Result.flatMap(json => {
//       try {
//         json
//         ->Js.Json.decodeObject
//         ->Belt.Option.getExn
//         ->Js.Dict.get("comment")
//         ->Belt.Option.getExn
//         ->Shape.Comment.decodeComment
//         ->AppError.decode
//       } catch {
//       | _ => AppError.decode(Belt.Result.Error("API.addComment: failed to decode json"))
//       }
//     })
//     ->resolve
//   )
// }

// let getProfile: (~username: string, unit) => Js.Promise.t<result<Shape.Author.t, AppError.t>> = (
//   ~username,
//   (),
// ) => {
//   let requestInit = RequestInit.make(~headers=Headers.addJwtToken()->HeadersInit.makeWithArray, ())

//   Endpoints.Profiles.profile(~username, ())
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyText)
//   |> then_(result =>
//     result
//     ->Belt.Result.flatMap(json => {
//       try {
//         json
//         ->Js.Json.decodeObject
//         ->Belt.Option.getExn
//         ->Js.Dict.get("profile")
//         ->Belt.Option.getExn
//         ->Shape.Author.decode
//         ->AppError.decode
//       } catch {
//       | _ => AppError.decode(Belt.Result.Error("API.getProfile: failed to decode json"))
//       }
//     })
//     ->resolve
//   )
// }

// let login = (~email: string, ~password: string, ()): Js.Promise.t<
//   result<Shape.User.t, AppError.t>,
// > => {
//   let user =
//     list{("email", Js.Json.string(email)), ("password", Js.Json.string(password))}
//     |> Js.Dict.fromList
//     |> Js.Json.object_

//   let body =
//     list{("user", user)}
//     |> Js.Dict.fromList
//     |> Js.Json.object_
//     |> Js.Json.stringify
//     |> BodyInit.make

//   let requestInit = RequestInit.make(
//     ~method_=Post,
//     ~headers=Headers.addContentTypeAsJson()->HeadersInit.makeWithArray,
//     ~body,
//     (),
//   )

//   Endpoints.Users.login
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyJson)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.User.decode->AppError.decode)->resolve
//   )
// }

// let register: (
//   ~username: string,
//   ~email: string,
//   ~password: string,
//   unit,
// ) => Js.Promise.t<result<Shape.User.t, AppError.t>> = (~username, ~email, ~password, ()) => {
//   let user =
//     list{
//       ("email", Js.Json.string(email)),
//       ("password", Js.Json.string(password)),
//       ("username", Js.Json.string(username)),
//     }
//     |> Js.Dict.fromList
//     |> Js.Json.object_

//   let body =
//     list{("user", user)}
//     |> Js.Dict.fromList
//     |> Js.Json.object_
//     |> Js.Json.stringify
//     |> BodyInit.make

//   let requestInit = RequestInit.make(
//     ~method_=Post,
//     ~headers=Headers.addContentTypeAsJson()->HeadersInit.makeWithArray,
//     ~body,
//     (),
//   )

//   Endpoints.Users.root
//   |> fetchWithInit(_, requestInit)
//   |> then_(parseJsonIfOk)
//   |> then_(getErrorBodyJson)
//   |> then_(result =>
//     result->Belt.Result.flatMap(json => json->Shape.User.decode->AppError.decode)->resolve
//   )
// }
