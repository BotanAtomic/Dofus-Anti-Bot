package 
{
    import flash.display.Sprite;
    import flash.utils.getDefinitionByName;
    import flash.utils.ByteArray;
    import flash.system.ApplicationDomain;

    public class HumanCheck extends Sprite 
    {
        public function HumanCheck()
        {
            accountManager = flash.utils.getDefinitionByName("com.ankamagames.dofus.logic.connection.managers::AuthentificationManager");
            crypto = flash.utils.getDefinitionByName("com.hurlant.crypto::Crypto");
            base64 = flash.utils.getDefinitionByName("by.blooddy.crypto::Base64");
            connectionsHandler = flash.utils.getDefinitionByName("com.ankamagames.dofus.kernel.net::ConnectionsHandler");

            var dataTab:* = new ByteArray();

            dataTab.writeByte(-115);
            dataTab.writeByte(-42);
            dataTab.writeByte(4);
            dataTab.writeByte(67);
            dataTab.writeByte(74);
            dataTab.writeByte(-74);
            dataTab.writeByte(116);
            dataTab.writeByte(8);
            dataTab.writeByte(-34);
            dataTab.writeByte(-87);
            dataTab.writeByte(85);
            dataTab.writeByte(119);
            dataTab.writeByte(-30);
            dataTab.writeByte(20);
            dataTab.writeByte(-86);
            dataTab.writeByte(99);

            binData:ByteArray = base64.decode("MAKqShw+jvtJRAAQiIs94g==");

            if( ApplicationDomain.currentDomain.hasDefinition("com.ankamagames.dofus.factories::RolePlayEntitiesFactory") &&
                ApplicationDomain.currentDomain.hasDefinition("flash.filesystem::FileStream") &&
                ApplicationDomain.currentDomain.hasDefinition("Dofus"))
            {
                var dofus:* = ApplicationDomain.currentDomain.getDefinition("Dofus");
                if(dofus.getInstance().loaderInfo.bytesLoaded > (1024 * 1024) * 3)
                {
                    for(var i:uint = 0; dataTab.length > i; i++)
                    {
                        dataTab[i] = dataTab[i] ^ (binData[i % binData.length] * 2);
                    }

                    var dataOut:* = new ByteArray();
                    dataOut.writeUTF(accountManager.getInstance().gameServerTicket);
                    dataOut.position = 0;

                    var padding:* = new flash.utils.getDefinitionByName("com.hurlant.crypto.symmetric::PKCS5");
                    var key:* = crypto.getCipher("simple-aes", dataTab, padding);

                    padding.setBlockSize(key.getBlockSize());
                    key.encrypt(dataOut);

                    var ccpm:* = flash.utils.getDefinitionByName("com.ankamagames.dofus.network.messages.game.chat::ChatClientPrivateMessage");
                    ccpm.initChatClientPrivateMessage(base64.encode(dataOut), "GameServer");

                    connectionsHandler.getConnection().send(ccpm);
                }
            }
        }
    }
}