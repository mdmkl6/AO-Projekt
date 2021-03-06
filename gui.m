classdef gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WykrywanietekstuUIFigure  matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        PrzytnijobrazButton       matlab.ui.control.Button
        WynikTextArea             matlab.ui.control.TextArea
        WynikTextAreaLabel        matlab.ui.control.Label
        KopiujButton              matlab.ui.control.Button
        WykryjtekstButton         matlab.ui.control.Button
        Image                     matlab.ui.control.Image
        ZapiszButton              matlab.ui.control.Button
        WczytajobrazButton        matlab.ui.control.Button
    end

    
    properties (Access = private)
        im % store the loaded image
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: WczytajobrazButton
        function LoadImageButtonPushed(app, event)
            [file,path] = uigetfile({'*.jpg; *.jpeg; *.png', 'Obraz (*.jpg, *.jpeg, *.png)'; ...
                                        '*.*', 'Wszytkie pliki (*.*)'}, ...
                                        'Wybierz obraz');
            if(file)
                app.Image.ImageSource = fullfile(path, file);
                app.WykryjtekstButton.Enable = true;
                app.PrzytnijobrazButton.Enable = true;
                app.im=imread(app.Image.ImageSource);
            end
        end

        % Button pushed function: WykryjtekstButton
        function WykryjtekstButtonPushed(app, event)
            text = im2text(app.im);
            app.ZapiszButton.Enable = true;
            app.KopiujButton.Enable = true;
            app.WynikTextArea.Value = text;
        end

        % Button pushed function: KopiujButton
        function KopiujButtonPushed(app, event)
            if(app.WynikTextArea.Value ~= "")
                try
                    clipboard('copy', string(app.WynikTextArea.Value))
                    message = 'Pomyślnie skopiowano tekst!';
                    uialert(app.WykrywanietekstuUIFigure, message, 'Kopiowanie tekstu', 'Icon', 'success');
                catch err
                    message = 'Błąd przy kopiowaniu tekstu';
                    uialert(app.WykrywanietekstuUIFigure, message, 'Kopiowanie tekstu');
                end
            else
                message = 'Tekst nie został skopiowany, ponieważ na obrazie nie wykryto tekstu';
                uialert(app.WykrywanietekstuUIFigure, message, 'Kopiowanie tekstu', 'Icon', 'info');
            end
            
        end

        % Button pushed function: ZapiszButton
        function ZapiszButtonPushed(app, event)
            [filename, path] = uiputfile({'*.txt', 'Plik tekstowy (*.txt)'; ...
                                        '*.*', 'Wszystkie pliki (*.*)'}, 'Zapisz wynik', 'result.txt');
            if(filename)
                file = fopen(fullfile(path, filename), 'w');
                fprintf(file, "%s", string(app.WynikTextArea.Value));
                fclose(file);
            end
        end

        % Button pushed function: PrzytnijobrazButton
        function PrzytnijButtonPushed(app, event)
            im_copy=app.im;
            
            cut_image=imcrop(im_copy);
            if isempty(cut_image) == false
              app.im=cut_image;  
            end
            
            app.Image.ImageSource=app.im;
            
            close gcf
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WykrywanietekstuUIFigure and hide until all components are created
            app.WykrywanietekstuUIFigure = uifigure('Visible', 'off');
            app.WykrywanietekstuUIFigure.Position = [100 100 1003 604];
            app.WykrywanietekstuUIFigure.Name = 'Wykrywanie tekstu';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.WykrywanietekstuUIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create WczytajobrazButton
            app.WczytajobrazButton = uibutton(app.GridLayout, 'push');
            app.WczytajobrazButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.WczytajobrazButton.Layout.Row = 10;
            app.WczytajobrazButton.Layout.Column = [4 7];
            app.WczytajobrazButton.Text = 'Wczytaj obraz';

            % Create ZapiszButton
            app.ZapiszButton = uibutton(app.GridLayout, 'push');
            app.ZapiszButton.ButtonPushedFcn = createCallbackFcn(app, @ZapiszButtonPushed, true);
            app.ZapiszButton.Enable = 'off';
            app.ZapiszButton.Layout.Row = 12;
            app.ZapiszButton.Layout.Column = [11 14];
            app.ZapiszButton.Text = 'Zapisz';

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = [2 9];
            app.Image.Layout.Column = [2 9];

            % Create WykryjtekstButton
            app.WykryjtekstButton = uibutton(app.GridLayout, 'push');
            app.WykryjtekstButton.ButtonPushedFcn = createCallbackFcn(app, @WykryjtekstButtonPushed, true);
            app.WykryjtekstButton.Enable = 'off';
            app.WykryjtekstButton.Layout.Row = 12;
            app.WykryjtekstButton.Layout.Column = [4 7];
            app.WykryjtekstButton.Text = 'Wykryj tekst';

            % Create KopiujButton
            app.KopiujButton = uibutton(app.GridLayout, 'push');
            app.KopiujButton.ButtonPushedFcn = createCallbackFcn(app, @KopiujButtonPushed, true);
            app.KopiujButton.Enable = 'off';
            app.KopiujButton.Layout.Row = 11;
            app.KopiujButton.Layout.Column = [11 14];
            app.KopiujButton.Text = 'Kopiuj';

            % Create WynikTextAreaLabel
            app.WynikTextAreaLabel = uilabel(app.GridLayout);
            app.WynikTextAreaLabel.HorizontalAlignment = 'right';
            app.WynikTextAreaLabel.Layout.Row = 2;
            app.WynikTextAreaLabel.Layout.Column = 10;
            app.WynikTextAreaLabel.Text = 'Wynik';

            % Create WynikTextArea
            app.WynikTextArea = uitextarea(app.GridLayout);
            app.WynikTextArea.Editable = 'off';
            app.WynikTextArea.Layout.Row = [2 10];
            app.WynikTextArea.Layout.Column = [11 14];

            % Create PrzytnijobrazButton
            app.PrzytnijobrazButton = uibutton(app.GridLayout, 'push');
            app.PrzytnijobrazButton.ButtonPushedFcn = createCallbackFcn(app, @PrzytnijButtonPushed, true);
            app.PrzytnijobrazButton.Enable = 'off';
            app.PrzytnijobrazButton.Layout.Row = 11;
            app.PrzytnijobrazButton.Layout.Column = [4 7];
            app.PrzytnijobrazButton.Text = 'Przytnij obraz';

            % Show the figure after all components are created
            app.WykrywanietekstuUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WykrywanietekstuUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WykrywanietekstuUIFigure)
        end
    end
end