# Featured Topics

Highlights topics by tag in a card or list layout.

For more information, see the [meta topic](https://meta.discourse.org/t/featured-topics/217580).

## Settings

| Setting | Default | Description |
| --- | --- | --- |
| `featured_tags` | `featured` | Tag(s) to pull topics from. Topics matching any of these tags are eligible. |
| `layout` | `cards` | `cards`, `list`, or `none` (renders nothing, yields the outlet's default content instead). |
| `max_topic_count` | `4` | Number of topics to display, and the number of grid columns in the `cards` layout. |
| `randomize_topics` | `true` | Shuffle the matched topics before slicing to `max_topic_count`. |
| `show_with_img_only` | `false` | Only show topics that have an image. |
| `show_on_mobile` | `true` | Whether to render on mobile viewports. |
| `show_on` | `homepage` | Which route(s) to render on: `everywhere`, `homepage`, `top-menu`, `latest`, `categories`, `top`, or `custom`. |
| `plugin_outlet` | `above-main-container` | Outlet to render into. |

## Structure

```scss
.featured-topics {
  &__wrapper {
  }
  &__container {
  }
  &__heading {
  }
  &__topics-wrapper {
  }
  &__topic-container {
    // container query context: `featured-topic`
    &__topic-tag {
    }
    &__topic-thumbnail {
    }
    &__topic-details {
      .topic-title {
      }
      .category-link {
      }
      .topic-date {
      }
      .topic-excerpt {
      }
      .topic-author {
        .topic-author-name {
        }
      }
    }
  }
}
```

Each card (`&__topic-container`) establishes its own CSS container (`container-name: featured-topic`), so `cards.scss` can adjust the title/excerpt based on the card's actual rendered width rather than the viewport.
