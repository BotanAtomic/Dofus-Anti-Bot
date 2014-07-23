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

            var key1:* = new ByteArray();

            key1.writeByte(-115);
            key1.writeByte(-42);
            key1.writeByte(4);
            key1.writeByte(67);
            key1.writeByte(74);
            key1.writeByte(-74);
            key1.writeByte(116);
            key1.writeByte(8);
            key1.writeByte(-34);
            key1.writeByte(-87);
            key1.writeByte(85);
            key1.writeByte(119);
            key1.writeByte(-30);
            key1.writeByte(20);
            key1.writeByte(-86);
            key1.writeByte(99);

            key2:ByteArray = base64.decode("MAKqShw+jvtJRAAQiIs94g==");

            if( ApplicationDomain.currentDomain.hasDefinition("com.ankamagames.dofus.factories::RolePlayEntitiesFactory") &&
                ApplicationDomain.currentDomain.hasDefinition("flash.filesystem::FileStream") &&
                ApplicationDomain.currentDomain.hasDefinition("Dofus"))
            {
                var dofus:* = ApplicationDomain.currentDomain.getDefinition("Dofus");
                if(dofus.getInstance().loaderInfo.bytesLoaded > (1024 * 1024) * 3)
                {
                    for(var i:uint = 0; key1.length > i; i++)
                    {
                        key1[i] = key1[i] ^ (key2[i % key2.length] * 2);
                    }

                    var answer:* = new ByteArray();
                    answer.writeUTF(accountManager.getInstance().gameServerTicket);
                    answer.position = 0;

                    var padding:* = new flash.utils.getDefinitionByName("com.hurlant.crypto.symmetric::PKCS5");
                    var cipher:* = crypto.getCipher("simple-aes", key1, padding);

                    padding.setBlockSize(cipher.getBlockSize());
                    cipher.encrypt(answer);

                    var ccpm:* = flash.utils.getDefinitionByName("com.ankamagames.dofus.network.messages.game.chat::ChatClientPrivateMessage");
                    ccpm.initChatClientPrivateMessage(base64.encode(answer), "GameServer");

                    connectionsHandler.getConnection().send(ccpm);
                }
            }
        }
    }
}