import Component from "@glimmer/component";
import { service } from "@ember/service";
import { bind } from "discourse/lib/decorators";
import { defaultHomepage } from "discourse/lib/utilities";
import DAsyncContent from "discourse/ui-kit/d-async-content";
import { i18n } from "discourse-i18n";
import FeaturedTopic from "./featured-topic";

export default class FeaturedTopics extends Component {
  @service router;
  @service store;
  @service siteSettings;

  <template>
    {{#if this.showOnRoute}}
      <div
        class="featured-topics featured-topics__wrapper
          {{settings.plugin_outlet}}"
      >
        <DAsyncContent @asyncData={{this.fetchFeaturedTopics}}>
          <:content as |topics|>
            <div class="featured-topics__container">
              <h2 class="featured-topics__heading">{{i18n
                  (themePrefix "heading")
                }}</h2>
              <div class="featured-topics__topics-wrapper">
                {{#each topics as |topic|}}
                  <FeaturedTopic @topic={{topic}} />
                {{/each}}
              </div>
            </div>
          </:content>
          <:empty></:empty>
        </DAsyncContent>
      </div>
    {{else}}
      {{yield}}
    {{/if}}
  </template>

  @bind
  async fetchFeaturedTopics() {
    const topicList = await this.store.findFiltered("topicList", {
      filter: "latest",
      params: {
        order: "activity",
        tags: this.featuredTags,
      },
    });

    let topics = topicList.topics;

    if (settings.show_with_img_only) {
      topics = topics.filter((topic) => topic.image_url);
    }

    if (settings.randomize_topics) {
      topics = this.shuffle(topics);
    }

    return topics.slice(0, settings.max_topic_count);
  }

  shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  }

  get featuredTags() {
    return settings.featured_tags.split("|");
  }

  get showOnRoute() {
    const currentRoute = this.router.currentRouteName;
    switch (settings.show_on) {
      case "everywhere":
        return !currentRoute.includes("admin");
      case "homepage":
        return currentRoute === `discovery.${defaultHomepage()}`;
      case "top-menu":
        const topMenu = this.siteSettings.top_menu;
        const targets = topMenu.split("|").map((opt) => `discovery.${opt}`);
        return targets.includes(currentRoute);
      case "latest":
        return currentRoute === `discovery.latest`;
      case "categories":
        return currentRoute === `discovery.categories`;
      case "top":
        return currentRoute === `discovery.top`;
      case "custom":
        return currentRoute === `discovery.custom`;
      default:
        return false;
    }
  }
}
