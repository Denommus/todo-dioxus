#![allow(non_snake_case)]

use dioxus::prelude::*;
use tracing::Level;


#[derive(Clone, Debug, PartialEq, Eq, Props)]
struct TodoItem {
    contents: String,
    done: bool,
}

#[derive(Clone, Routable, Debug, PartialEq)]
enum Route {
    #[route("/")]
    Home {},
}

fn main() {
    // Init logger
    dioxus_logger::init(Level::INFO).expect("failed to init logger");

    let cfg = dioxus::desktop::Config::new()
        .with_custom_head(r#"<link rel="stylesheet" href="tailwind.css">"#.to_string());
    LaunchBuilder::desktop().with_cfg(cfg).launch(App);
}

#[component]
fn App() -> Element {
    rsx! {
        Router::<Route> {}
    }
}

#[component]
fn TodoList(items: Signal<Vec<TodoItem>>) -> Element {
    let rendered_items =
        items.iter().zip(0..).map(|(item, i)| {
            let style = if item.done {
                r#"
                  text-decoration: line-through
                "#
            } else {
                ""
            };
            rsx! {
                li {
                    style: style,
                    {item.contents.clone()}
                    input {
                        r#type: "checkbox",
                        checked: item.done,
                        onchange: move |_| {
                            let mut writer = items.write();
                            writer[i].done = !writer[i].done;
                        }
                    }
                }
            }
        });

    rsx! {
        ul {
            {rendered_items}
            button {
                onclick: move |_| {
                    items.set(items.iter().filter_map(|x| if x.done {
                        None
                    } else {
                        Some(TodoItem {
                            contents: x.contents.clone(),
                            done: false,
                        })
                    }).collect())
                },
                "Clear"
            }
        }
    }
}

#[component]
fn Home() -> Element {
    let mut input = use_signal(|| "".to_string());
    let mut items: Signal<Vec<TodoItem>> = use_signal(|| vec![]);

    rsx! {
        div {
            h1 { "Todo App" }
            input {
                value: "{input}",
                oninput: move |event| input.set(event.value())
            }
            button {
                onclick: move |_| {
                    items.write().push(TodoItem {
                        contents: input.read().clone(),
                        done: false,
                    });
                    input.set("".to_string())
                },
                "Add"
            }
            TodoList { items: items }
        }
    }
}
