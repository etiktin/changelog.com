defmodule Changelog.PageTitle do
  alias Changelog.{AuthView, EpisodeView, PageView, PersonView, PodcastView, PostView}

  @suffix "Changelog"

  def page_title(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " | " <> @suffix

  defp get(%{view_module: AuthView}), do: "Sign In"

  defp get(%{view_module: EpisodeView, view_template: "show.html", podcast: podcast, episode: episode}) do
    "#{podcast.name} ##{EpisodeView.numbered_title(episode)}"
  end

  defp get(%{view_module: PageView, view_template: template}) do
    case template do
      "home.html"    -> nil
      "weekly.html"  -> "Subscribe to Changelog Weekly"
      "nightly.html" -> "Subscribe to Changelog Nightly"
      _else ->
        template
        |> String.replace(".html", "")
        |> String.split("_")
        |> Enum.map(fn(s) -> String.capitalize(s) end)
        |> Enum.join(" ")
    end
  end

  defp get(%{view_module: PodcastView, view_template: "index.html"}) do
    "All Podcasts"
  end

  defp get(%{view_module: PodcastView, view_template: "master.html"}) do
    "Changelog Master Feed"
  end

  defp get(%{view_module: PodcastView, view_template: "archive.html", podcast: podcast}) do
    "#{podcast.name} Episode Archive"
  end

  defp get(%{view_module: PodcastView, podcast: podcast}) do
    "#{podcast.name} with #{PersonView.comma_separated_names(podcast.hosts)}"
  end

  defp get(%{view_module: PostView, post: post}) do
    post.title
  end

  defp get(_), do: nil
end