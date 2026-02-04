defmodule JournalWeb.JournalLive.FormComponent do
  use JournalWeb, :live_component


  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-base-100 border-4 border-primary/20 shadow-2xl relative" style="border-style: double;">
      <!-- Vintage Card Header -->
      <div class="border-b-2 border-primary/20 px-8 py-6 bg-base-200/30">
        <div class="flex justify-between items-center">
          <h2 class="text-2xl font-display text-primary"><%= @title %></h2>
          <span class="text-xs font-mono text-base-content/40 uppercase tracking-widest">Entry Form</span>
        </div>
      </div>

      <.form
        for={@form}
        id="entry-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="px-8 py-8 space-y-8"
      >
        <!-- Title Field - Typewriter Style -->
        <div class="form-control">
          <label class="mb-2 flex items-center gap-2">
            <span class="text-xs font-mono text-base-content/60 uppercase tracking-widest">Title</span>
            <span class="flex-1 border-b border-dotted border-base-content/20"></span>
          </label>
          <input 
            type="text" 
            name="title" 
            value={@form[:title].value} 
            class="w-full bg-transparent border-2 border-base-content/20 focus:border-primary px-4 py-3 text-xl font-display text-primary placeholder-base-content/30 transition-all focus:shadow-lg" 
            placeholder="Untitled Entry..." 
            autocomplete="off"
          />
          <p class="text-error text-xs mt-2 font-mono"><%= Enum.map(@form[:title].errors, &translate_error/1) |> Enum.join(", ") %></p>
        </div>

        <!-- Content Field - Manuscript Style -->
        <div class="form-control">
          <label class="mb-2 flex items-center gap-2">
            <span class="text-xs font-mono text-base-content/60 uppercase tracking-widest">Content</span>
            <span class="flex-1 border-b border-dotted border-base-content/20"></span>
          </label>
          <div class="relative">
            <!-- Lined Paper Effect -->
            <div class="absolute inset-0 pointer-events-none" style="background-image: repeating-linear-gradient(transparent, transparent 31px, rgba(var(--color-base-content) / 0.05) 31px, rgba(var(--color-base-content) / 0.05) 32px);"></div>
            <textarea 
              name="content" 
              class="relative w-full bg-transparent border-2 border-base-content/20 focus:border-primary px-4 py-4 text-lg font-serif leading-8 resize-none placeholder-base-content/30 transition-all focus:shadow-lg min-h-[400px]" 
              placeholder="Begin writing..."
              style="line-height: 32px;"
            ><%= @form[:content].value %></textarea>
          </div>
          <p class="text-error text-xs mt-2 font-mono"><%= Enum.map(@form[:content].errors, &translate_error/1) |> Enum.join(", ") %></p>
        </div>

        <!-- Form Actions - Stamp Style -->
        <div class="flex justify-between items-center pt-6 border-t-2 border-dashed border-base-content/10">
          <div class="flex items-center gap-2">
            <div class="w-2 h-2 rounded-full bg-primary/50"></div>
            <span class="text-xs font-mono text-base-content/40 italic">
              <%= if @form.source.action == :create, do: "New Archive Entry", else: "Editing Entry" %>
            </span>
          </div>
          <button 
            type="submit" 
            phx-disable-with="Cataloguing..." 
            class="group relative px-8 py-3 bg-primary hover:bg-primary/90 text-primary-content border-2 border-primary-content/20 transition-all duration-300 hover:shadow-xl hover:-translate-y-0.5"
          >
            <span class="font-mono uppercase tracking-widest text-sm">Archive Entry</span>
            <!-- Stamp Effect -->
            <div class="absolute inset-0 border-2 border-dashed border-primary-content/30 -m-1 opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  defp assign_form(socket) do
    form = AshPhoenix.Form.for_create(Journal.Journals.Entry, :create, api: Journal.Journals, actor: socket.assigns.current_user)
    assign(socket, :form, to_form(form))
  end

  @impl true
  def handle_event("validate", %{"title" => title, "content" => content}, socket) do
     form = AshPhoenix.Form.for_create(Journal.Journals.Entry, :create, api: Journal.Journals, actor: socket.assigns.current_user)
     |> AshPhoenix.Form.validate(params: %{"title" => title, "content" => content})
     
     {:noreply, assign(socket, form: to_form(form))}
  end

  @impl true
  def handle_event("save", %{"title" => title, "content" => content}, socket) do
    case Journal.Journals.create_entry(%{title: title, content: content}, actor: socket.assigns.current_user) do
      {:ok, entry} ->
        send(self(), {:entry_created, entry})
        {:noreply,
         socket
         |> put_flash(:info, "Entry archived successfully.")
         |> push_patch(to: socket.assigns.patch)}

      {:error, _error} ->
        {:noreply, put_flash(socket, :error, "Failed to create entry. Please try again.")}
    end
  end
  

end
