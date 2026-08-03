import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { trustHTML } from "@ember/template";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import { emojiUnescape } from "discourse/lib/text";
import DiscourseURL from "discourse/lib/url";
import DUserLink from "discourse/ui-kit/d-user-link";
import dAvatar from "discourse/ui-kit/helpers/d-avatar";
import dCategoryLink from "discourse/ui-kit/helpers/d-category-link";
import dFormatDate from "discourse/ui-kit/helpers/d-format-date";

export default class FeaturedTopic extends Component {
  <template>
    {{! eslint-disable ember/template-no-invalid-interactive }}
    <div
      class="featured-topics__topic-container
        {{this.tagName}}
        {{this.thumbnail}}
        "
      {{on "click" this.handleClick}}
    >

      {{#if this.tag}}
        <div class="featured-topics__topic-tag">
          <a
            href={{this.tagUrl}}
            data-tag-name={{this.tagName}}
            class="discourse-tag box"
          >{{this.tagName}}</a>
        </div>
      {{/if}}

      {{#if @topic.thumbnails}}
        <div class="featured-topics__topic-thumbnail">
          <img
            src={{@topic.image_url}}
            srcset={{this.srcset}}
            sizes={{this.sizes}}
            loading="lazy"
          />
        </div>
      {{/if}}

      <div class="featured-topics__topic-details">
        <h2 class="topic-title">
          <a href={{this.unreadUrl}}>{{trustHTML this.fancyTitle}}</a>
        </h2>
        <div class="category-link">{{dCategoryLink @topic.category}}</div>
        <span class="topic-date">{{dFormatDate
            @topic.created_at
            format="tiny"
          }}</span>
        {{#if @topic.hasExcerpt}}
          <div class="topic-excerpt">
            {{trustHTML @topic.excerpt}}
          </div>
        {{/if}}
        <div class="topic-author">
          <DUserLink @user={{@topic.creator}}>
            {{dAvatar @topic.creator imageSize="small"}}
            <span class="topic-author-name">{{@topic.creator.name}}</span>
          </DUserLink>
        </div>
      </div>

    </div>
  </template>

  @action
  handleClick(event) {
    if (event.target.closest("a")) {
      return;
    }

    if (wantsNewWindow(event)) {
      return;
    }

    DiscourseURL.routeTo(this.unreadUrl);
  }

  get fancyTitle() {
    return emojiUnescape(this.args.topic.fancy_title);
  }

  get unreadUrl() {
    return this.args.topic.linked_post_number
      ? this.args.topic.urlForPostNumber(this.args.topic.linked_post_number)
      : this.args.topic.get("lastUnreadUrl");
  }

  get thumbnail() {
    if (!this.args.topic.thumbnails) {
      return;
    }
    return "thumbnail";
  }

  get tag() {
    return this.args.topic.tags.find((tag) =>
      settings.featured_tags.split("|").includes(tag.name)
    );
  }

  get tagName() {
    return this.tag?.name;
  }

  get tagUrl() {
    return `/tag/${this.tag?.slug}`;
  }

  get srcset() {
    return this.args.topic.thumbnails
      .filter((t) => t.url && t.width)
      .map((t) => `${t.url} ${t.width}w`)
      .join(", ");
  }

  get sizes() {
    const columnWidth = Math.round(100 / settings.max_topic_count);
    return `(max-width: 640px) 100vw, ${columnWidth}vw`;
  }
}
